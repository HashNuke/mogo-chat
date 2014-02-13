defmodule AppConfig do

  defmacro read_db_config do
    cond do
      System.get_env("STACK") == "cedar" ->
        quote do
          def url do
            System.get_env("DATABASE_URL")
          end
        end

      File.exists?("config/database.json")->
        {:ok, config_json} = File.read "config/database.json"
        {:ok, config} = JSEX.decode config_json
        database_url = config["#{Mix.env}"]

        quote do
          def url do
            unquote(database_url)
          end
        end
      true ->
        raise("Database details not found. Either create a config/database.json or set DATABASE_URL env")
    end

  end
end
