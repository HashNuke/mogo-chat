defmodule Wilcog do

  def compile(asset_path, output_path, options \\ []) do
    default_precompile_list = ['application.js', 'application.css']
    extra_precompile_list = :proplists.get_value(:precompile, options, [])
    precompile_list = default_precompile_list ++ extra_precompile_list
    graph = FileTree.build('#{File.cwd!}/assets')

    precompile_vertices = get_vertices_of_precompile_list(graph, precompile_list)
    create_dir_if_not_exists(output_path)

    IO.inspect "compiling assets.."

    compile_assets(precompile_vertices, graph, output_path, options)
  end


  def get_vertices_of_precompile_list(graph, precompile_list) do
    elements = :digraph_utils.topsort(graph)

    fold_function = fn(name, {precompile_vertices, precompile_list})->
      {vertex, data} = :digraph.vertex(graph, name)
      if :lists.member(data[:output], precompile_list) do
        {precompile_vertices ++ [vertex], precompile_list}
      else
        {precompile_vertices, precompile_list}
      end
    end
    {precompile_vertices, _} = :lists.foldr(fold_function, {[], precompile_list}, elements)
    precompile_vertices
  end


  def create_dir_if_not_exists(path) do
    if !:filelib.is_dir(path) do
      :ok = :file.make_dir(path)
    end
  end


  def write_file(file_path, contents) do
    {:ok, io_device} = :file.open(file_path, [:write])
    :file.write(io_device, contents)
    :file.close(io_device)
  end


  def compile_assets([], graph, output_path, options) do
    IO.inspect "Done compiling assets ~!"
  end


  def compile_assets([vertex|other_vertices], graph, output_path, options) do
    {_, data} = :digraph.vertex(graph, vertex)
    compiled_dependencies = compile_dependencies(vertex, data[:dependencies], graph, options)
    contents = :string.join(compiled_dependencies, ' ')

    # current_file_contents = compile_without_dependencies(vertex, vertex_data, graph, options)
    write_file('#{output_path}/#{data[:output]}', contents)

    compile_assets(other_vertices, graph, output_path, options)
  end


  def compile_dependencies(parent_file, dependencies, graph, options) do
    :lists.map(fn(dependency_info)->
      case dependency_info do
        :self ->
          ''
        {:file, dependency} ->
          dependency_vertex = guess_vertex(dependency, "file", parent_file, graph)
          if dependency_vertex == nil do
            raise "No match found for #{dependency} in #{parent_file}"
          end

          {_, dependency_vertex_data} = :digraph.vertex(graph, dependency_vertex)
          compile_file(dependency, dependency_vertex_data, graph, options)
        {:tree, dependency} ->
          dependency_vertex = guess_vertex(dependency, "dir", parent_file, graph)

          if dependency_vertex == nil do
            raise "No match found for #{dependency} in #{parent_file}"
          else
            IO.inspect "Match for #{dependency} is #{dependency_vertex} in #{parent_file}"
          end

          {_, dependency_vertex_data} = :digraph.vertex(graph, dependency_vertex)
          compile_dir(dependency, dependency_vertex_data, graph, options)
      end
    end, dependencies)
  end


  def compile_dir(vertex, vertex_data, graph, options) do
    'definitely'
  end


  def compile_without_dependencies(vertex, vertex_data, graph, options) do
    'definitely'
  end


  def compile_file(vertex, vertex_data, graph, options) do
    'definitely'
  end


  def guess_vertex(asset_name, type, reference_vertex, graph) do
    pattern = FileUtils.possible_path_relative_to_file(reference_vertex, asset_name)
    vertices = :digraph_utils.topsort(graph)

    find_matching_vertex(vertices, type, pattern, graph)
  end


  def find_matching_vertex([], type, pattern, graph) do
    nil
  end

  def find_matching_vertex([vertex | others], type, pattern, graph) do
    tokens = :re.split(vertex, pattern, [{:return, :list}])
    {_, vertex_data} = :digraph.vertex(graph, vertex)

    vertex_type = if vertex_data[:type] == :dir do
      "dir"
    else
      "file"
    end

    cond do
      vertex_type != type ->
        find_matching_vertex(others, type, pattern, graph)
      hd(tokens) == [] ->
        vertex
      true ->
        find_matching_vertex(others, type, pattern, graph)
    end
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


defmodule FileTree do

  def build(path) do
    graph = :digraph.new([:acyclic])
    {:ok, dir_list} = :file.list_dir(path)
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
        {:ok, dir_list} = :file.list_dir(item_path)
        vertex = :digraph.add_vertex(graph, item_path, [type: :dir, dependencies: []])
        :digraph.add_edge(graph, parent_vertex, vertex)
        build(item_path, dir_list, graph)
      false ->
        props = file_properties(item_path)
        vertex = :digraph.add_vertex(graph, item_path, props)
        :digraph.add_edge(graph, parent_vertex, vertex)
        graph
    end
    build(parent, items, graph)
  end


  def file_properties(path) do
    props = :filename.basename(path)
      |> FileUtils.extract_info()
      |> :lists.merge([type: :file, compiled: nil])

    case js_or_css?(props[:output]) do
      true ->
        props ++ [dependencies: DirectiveParser.parse(path)]
      false ->
        props
    end
  end


  def js_or_css?(output_name) do
    parts = :string.tokens(output_name, '.')
    :lists.member(:lists.last(parts), ['js', 'css', 'coffee', 'scss'])
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


defmodule FileUtils do

  def possible_path_relative_to_file(file, relative_path) do
    parent_path = :filename.dirname(file)
    # We don't use :filename.absname because we need the correct absolute path
    # to fetch from the file tree graph
    parts = :string.tokens(relative_path, '/')

    # the parent dir is fixed (something like cd-ed) according to the "..",
    # while the include path's ".." is popped
    {parent_parts, include_parts} = :lists.foldl(fn(part, {parent_path_parts, include_path_parts})->
      case part do
        '..' ->
          new_parent_path_parts = parent_path_parts
          |> :lists.reverse()
          |> tl()
          |> :lists.reverse()
          {new_parent_path_parts, tl(include_path_parts)}
        '.' ->
          {parent_path_parts, tl(include_path_parts)}
        _ ->
          {parent_path_parts, include_path_parts}
      end
    end, {:string.tokens(parent_path, '/'), parts}, parts)
    '/' ++ :string.join(parent_parts ++ include_parts, '/')
  end

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
    |> :string.join('.')
  end

  def compute_basename(part1, []) do
    part1
  end

  def compute_basename(part1, other_parts) do
    [part1 | other_parts] |> :string.join('.')
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
    parts = :string.tokens(source_filename, '.')
    first_part = hd(parts)
    {known_extensions, unknown_extensions} = tl(parts)
    |> group_extensions()

    if unknown_extensions != [] do
      unknown_extensions = :lists.reverse(unknown_extensions)
    end

    basename = compute_basename(first_part, unknown_extensions)
    compiled_name = compiled_name_for(source_filename, basename, known_extensions)

    [
      source: source_filename,
      output: compiled_name,
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

Wilcog.compile('#{File.cwd!}/assets', '#{File.cwd!}/priv/static/assets')

# IO.inspect :digraph.vertex(graph, "#{File.cwd!}/assets/javascripts/application.js")
# IO.inspect DirectiveParser.parse "#{File.cwd!}/assets/javascripts/application.js"
# IO.inspect FileUtils.possible_path_relative_to_file('#{File.cwd!}/assets/javascripts/application.js', '../notifications.js')
# IO.inspect FileUtils.possible_path_relative_to_file('#{File.cwd!}/assets/javascripts/application.js', 'notifications.js')
# IO.inspect FileUtils.possible_path_relative_to_file('#{File.cwd!}/assets/javascripts/application.js', 'notifications')
# IO.inspect FileUtils.possible_path_relative_to_file('#{File.cwd!}/assets/javascripts/application.js', 'notifications')
# IO.inspect FileUtils.possible_path_relative_to_file('#{File.cwd!}/assets/javascripts/application.js', './controllers')

# IO.inspect FileUtils.extract_info("manifest")
# IO.inspect FileUtils.extract_info("test.coffee")
# IO.inspect FileUtils.extract_info("test.scss")
# IO.inspect FileUtils.extract_info("test.css.scss")
# IO.inspect FileUtils.extract_info("jquery.2.0.3.min.js.coffee")
# IO.inspect FileUtils.extract_info("jquery.min.js")

# root = "#{File.cwd!}/assets"
# graph = FileTree.build("#{File.cwd!}/assets")
# {root_vertex, _} = :digraph.vertex(graph, root)
# IO.inspect :digraph.out_neighbours(graph, root_vertex)
