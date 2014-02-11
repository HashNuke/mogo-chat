defmodule AppConfig do

  defmacro read_db_config do
    {:ok, eex_config} = File.read "config/database.json"
    config_json = EEx.eval_string(eex_config)
    {:ok, config} = JSEX.decode config_json

    quote do
      def url do
        unquote(config["#{Mix.env}"])
      end
    end
  end

end
