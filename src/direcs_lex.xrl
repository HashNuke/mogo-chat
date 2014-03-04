Definitions.
Sc = \/\*
Ec = \*/
Dc=(require_self|require_tree|require)
Sws = [\s\t\r\n]
Ws = [\s\t\r\n]*
Sp = [\s\t]*
Path = ("[^\s\n]+"|[^\s\n]+)

Rules.
{Sws} : skip_token.
{Ws}\*{Sp}={Ws}{Dc}{Sp}{Path} : {token, {'DIRECTIVES', TokenLine, TokenChars}}.
. : skip_token.

Erlang code.
strip_quotes(StrChars) ->
  list_to_binary(string:substr(StrChars, 2, string:len(StrChars) - 2)).
