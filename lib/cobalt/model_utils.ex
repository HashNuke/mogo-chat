defmodule Cobalt.ModelUtils do

  defmacro __using__(_) do
    quote do
      def attributes(record, fields) do
        lc field inlist fields do
          { "#{field}", apply(record, :"#{field}", []) }
        end
      end
    end
  end

end
