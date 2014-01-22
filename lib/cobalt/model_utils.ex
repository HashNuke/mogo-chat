defmodule Cheko.ModelUtils do

  defmacro __using__(_) do
    quote do
      def attributes(record, fields) do
        lc field inlist fields do
          { "#{field}", apply(record, :"#{field}", []) }
        end
      end

      def assign_attributes(record, params) do
        Enum.reduce params, record, fn({field, value}, accumulated_record) ->
          apply(accumulated_record, :"#{field}", [value])
        end
      end
    end
  end

end
