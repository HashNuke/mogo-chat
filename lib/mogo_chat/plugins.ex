defmodule MogoChat.MessageParser do
  def parse_message(message) do
    cond do
      matches = Regex.named_captures(%r/\/play (?<sound>\w+)/g, message) ->
        {:sound, matches[:sound]}
      matches = Regex.named_captures(%r/\/me (?<announcement>.+)/g, message) ->
        {:me, matches[:announcement]}
      true ->
        message
    end
  end


  def parse_emoji(message) do
    #TODO
  end
end
