defmodule Wilcog do
  def compile(asset_path, _output_path, _options) do
    precompile = ["application.js", "application.css"]
    FileTree.build(asset_path)
  end
end

defmodule DirectiveParser do
  def parse(file) do
    {:ok, contents} = File.read(file)
    {:ok, directive_blocks, _} = :directive_block_scanner.string('#{contents}')
    parse_directives(directive_blocks)
  end



  def parse_directives([]) do
    []
  end

  def parse_directives([directive_block|_]) do
    {:directive_block, _, token_string} = directive_block
    {:ok, tokens, _} = :directive_scanner.string(token_string)

    directives = :lists.filtermap(fn({label, _, token_string})->
      case label == :directive do
        true -> {true, token_string}
        false -> false
      end
    end, tokens)
    parse_dependencies(directives)
  end


  def parse_dependencies(directives) do
    :lists.map(fn(directive)->
      command = :string.tokens(directive, ' ')
      get_dependency_from_require(command)
    end, directives)
  end


  def get_dependency_from_require(['require_self']) do
    :self
  end
  def get_dependency_from_require(['require_tree', relative_path]) do
    {:tree, relative_path}
  end
  def get_dependency_from_require(['require', path]) do
    {:file, path}
  end
end

IO.inspect DirectiveParser.parse("/Users/akashmanohar/projects/mogo-chat/test.css")

defmodule FileTree do

  def build(path) do
    graph = :digraph.new([:acyclic])
    {:ok, dir_list} = File.ls(path)
    :digraph.add_vertex(graph, path, [type: :dir])
    build(path, dir_list, graph)
  end

  def build(_parent, [], graph) do
    graph
  end

  def build(parent, [item|items], graph) do
    item_path = :filename.absname_join(parent, item)
    {parent_vertex, _label} = :digraph.vertex(graph, parent)

    graph = case :filelib.is_dir(item_path) do
      true ->
        {:ok, dir_list} = File.ls(item_path)
        vertex = :digraph.add_vertex(graph, item_path, [type: :dir])
        :digraph.add_edge(graph, parent_vertex, vertex)
        build(item_path, dir_list, graph)
      false ->
        props = :filename.basename(item_path)
                |> FilenameUtils.extract_info()
                |> :lists.merge([type: :file, compiled: nil])

        vertex = :digraph.add_vertex(graph, item_path, props)
        :digraph.add_edge(graph, parent_vertex, vertex)
        graph
    end
    build(parent, items, graph)
  end

end


defmodule Wilcog.CssCompiler do
end


defmodule Wilcog.JavascriptCompiler do
  def expected_extension(_filename) do
    "js"
  end
end


defmodule Wilcog.ScssCompiler do
  def expected_extension(_filename) do
    "css"
  end
end

defmodule Wilcog.CoffeeScriptCompiler do
  def expected_extension(_filename) do
    "js"
  end
end

defmodule Wilcog.DefaultCompiler do
end


defmodule FilenameUtils do

  def compiler_for(extension) do
    compilers[extension]
  end

  def compilers do
    [
      {"scss", Wilcog.ScssCompiler},
      {"js", Wilcog.JavascriptCompiler},
      {"css", Wilcog.CssCompiler},
      {"coffee", Wilcog.CoffeeScriptCompiler},
    ]
  end

  def compiled_name_for(_source_filename, basename, []) do
    basename
  end

  def compiled_name_for(source_filename, basename, known_extensions) do
    [basename] ++ [compute_extension(source_filename, :lists.last(known_extensions))]
    |> Enum.join(".")
  end

  def compute_basename(part1, []) do
    part1
  end

  def compute_basename(part1, other_parts) do
    [part1 | other_parts] |> Enum.join(".")
  end


  def compute_extension(source_filename, extension) do
    cond do
      compiler_for(extension) && defines_extension?(compiler_for(extension)) ->
        compiler_for(extension).expected_extension(source_filename)
      true -> extension
    end
  end


  def defines_extension?(module) do
    module.module_info[:exports][:expected_extension] == 1
  end


  def extract_info(source_filename) do
    parts = String.split(source_filename, ".")
    first_part = hd(parts)
    {known_extensions, unknown_extensions} = tl(parts)
    |> group_extensions()

    if unknown_extensions != [] do
      unknown_extensions = :lists.reverse(unknown_extensions)
    end

    basename = compute_basename(first_part, unknown_extensions)
    compiled_name = compiled_name_for(source_filename, basename, known_extensions)

    [
      source_name: source_filename,
      compiled_name: compiled_name,
      compilers: known_extensions
    ]
  end


  def group_extensions([]) do
    {[], []}
  end

  def group_extensions(extensions) do
    extensions
    |> :lists.reverse
    |> Enum.split_while fn(extension)->
      :lists.member(extension, Dict.keys(compilers))
    end
  end

end


# IO.inspect FilenameUtils.extract_info("manifest")
# IO.inspect FilenameUtils.extract_info("test.coffee")
# IO.inspect FilenameUtils.extract_info("test.scss")
# IO.inspect FilenameUtils.extract_info("test.css.scss")
# IO.inspect FilenameUtils.extract_info("jquery.2.0.3.min.js.coffee")
# IO.inspect FilenameUtils.extract_info("jquery.min.js")

root = "#{File.cwd!}/assets"
graph = FileTree.build("#{File.cwd!}/assets")
{root_vertex, _} = :digraph.vertex(graph, root)
IO.inspect :digraph.out_neighbours(graph, root_vertex)
