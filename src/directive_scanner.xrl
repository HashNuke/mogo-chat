Definitions.
Whitespace = [\s\t\r\n]
OptWhitespace = {Whitespace}*
Space = [\s\t]*
StartComment = (/\*|\#\#\#)
EndComment = (\*/|\#\#\#)
Path = [^\s\n]+
DirectiveCmd=(require_self|require_tree|require)
DirectiveWithPath = {DirectiveCmd}{Space}{Path}
DirectiveWithoutPath = {DirectiveCmd}{Space}
DirectiveLine = ({DirectiveWithPath}|{DirectiveWithoutPath})

Rules.
{Whitespace}     : skip_token.
{OptWhitespace}  : skip_token.
={Space}         : skip_token.
\*               : skip_token.
{StartComment}   : {token, {start_comment, TokenLine, TokenChars}}.
{DirectiveLine}  : {token, {directive, TokenLine, TokenChars}}.
{EndComment}     : {token, {end_comment, TokenLine, TokenChars}}.
.                : skip_token.

Erlang code.
