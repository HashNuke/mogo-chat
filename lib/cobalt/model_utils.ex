defmodule Cobalt.ModelUtils do

  def attributes(record, fields) do
    lc field inlist fields do
      { "#{field}", apply(record, :"#{field}", []) }
    end
  end

end
