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
        vertex = :digraph.add_vertex(graph, item_path, [type: :file, compiled: nil])
        :digraph.add_edge(graph, parent_vertex, vertex)
        graph
    end
    build(parent, items, graph)
  end
end


defmodule Wilcog.ScssCompiler do
end

defmodule Wilcog.CoffeeCompiler do
end

defmodule Wilcog.DefaultCompiler do
end


root = "#{File.cwd!}/assets"
graph = FileTree.build("#{File.cwd!}/assets")
{root_vertex, _} = :digraph.vertex(graph, root)
IO.inspect :digraph.out_neighbours(graph, root_vertex)
