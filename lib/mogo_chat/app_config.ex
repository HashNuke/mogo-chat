defmodule AppConfig do

  defmacro read_db_config do
    cond do
      database_url = System.get_env("DB_URL") ->
        database_url
      File.exists?("config/database.json")->
        {:ok, config_json} = File.read "config/database.json"
        {:ok, config} = JSEX.decode config_json
        database_url = config["#{Mix.env}"]
      true ->
        raise("Database details not found. Either create a config/database.json or set DATABASE_URL env")
    end

    quote do
      def url do
        unquote(database_url)
      end
    end
  end

end
