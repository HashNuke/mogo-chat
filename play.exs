defmodule FileTree do

  def build(path) do
    tree = :gb_trees.empty()
    {:ok, dir_list} = File.ls(path)
    build(path, dir_list, tree)
  end

  def build(parent, [], tree) do
    tree
  end

  def build(parent, [item|items], tree) do
    item_path = :filename.absname_join(parent, item)

    updated_tree = case :filelib.is_dir(item_path) do
      true ->
        {:ok, dir_list} = File.ls(item_path)
        new_tree = :gb_trees.insert(item_path, [type: :dir, path: item_path], tree)
        build(item_path, dir_list, new_tree)
      false ->
        :gb_trees.insert(item_path, [type: :file, path: item_path, compiled: nil], tree)
    end
    build(parent, items, updated_tree)
  end
end


defmodule Wilcog.ScssCompiler do
  
end

defmodule Wilcog.CoffeeCompiler do
end

defmodule Wilcog.DefaultCompiler do
end


IO.inspect :gb_trees.keys(FileTree.build("#{File.cwd!}/assets"))