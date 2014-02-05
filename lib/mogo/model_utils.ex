defmodule Mogo.ModelUtils do

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

      def timestamp(ecto_datetime) do
        datetime = {
          {ecto_datetime.year, ecto_datetime.month, ecto_datetime.day},
          {ecto_datetime.hour, ecto_datetime.min, ecto_datetime.sec}
        }
        "#{:qdate.to_string("Y-m-d", datetime)}T#{:qdate.to_string("H:i:s", datetime)}Z"
      end

    end
  end

end
