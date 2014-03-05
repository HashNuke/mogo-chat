Definitions.
Sc = \/\*
Ec = \*/
Dc=(require_self|require_tree|require)
Sws = [\s\t\r\n]
Ws = [\s\t\r\n]*
Sp = [\s\t]*
Path = [^\s\n]+
DcLine = {Dc}{Sp}{Path}

Rules.
{Sws}    : skip_token.
{Ws}     : skip_token.
={Ws}    : skip_token.
\*       : skip_token.
{Sc}     : {token, {start_comment, TokenLine, TokenChars}}.
{DcLine} : {token, {directive, TokenLine, TokenChars}}.
{Ec}     : {token, {end_comment, TokenLine, TokenChars}}.
.        : skip_token.

Erlang code.
