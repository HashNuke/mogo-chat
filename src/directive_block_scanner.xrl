Definitions.
Whitespace = [\s\t\r\n]
OptWhitespace = {Whitespace}*
Space = [\s\t]*
Path = [^\s\n]+

StartComment = (/\*|\#\#\#)
EndComment = (\*/|\#\#\#)

DirectiveCmd=(require_self|require_tree|require)
DirectiveLine = {DirectiveCmd}{Space}{Path}

Css = {StartComment}{OptWhitespace}(\**{OptWhitespace}\={OptWhitespace}{DirectiveLine}{OptWhitespace})+{EndComment}


Rules.
{Whitespace}     : skip_token.
{Css}            : {token, {directive_block, TokenLine, TokenChars}}.
.                : skip_token.

Erlang code.
