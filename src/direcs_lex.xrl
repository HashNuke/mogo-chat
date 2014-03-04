Definitions.
D = [0-9]
S = (\+|\-)?
H = [a-zA-Z0-9]
Spl = (\\((u{H}{4})|([\"trf\bn\/])))

Rules.
([\s\t\r\n]+)                  : skip_token.
[\{\}\[\]\,\:]                 : {token, {list_to_atom(TokenChars), TokenLine}}.
('true'|'false'|'null')        : {token, {list_to_atom(TokenChars), TokenLine}}.
{S}{D}+                        : {token,{'NUMBER',TokenLine,list_to_integer(TokenChars)}}.
{S}{D}+\.{D}+((E|e){S}{D}+)?   : {token,{'NUMBER',TokenLine,list_to_float(TokenChars)}}.
"(([^\\\"])|{Spl})*"           : {token,{'STRING',TokenLine,strip_quotes(TokenChars)}}.

Erlang code.
strip_quotes(StrChars) ->
  list_to_binary(string:substr(StrChars, 2, string:len(StrChars) - 2)).
