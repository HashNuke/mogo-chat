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

Css = {StartComment}{OptWhitespace}(\**{OptWhitespace}\={OptWhitespace}{DirectiveLine}{OptWhitespace})+{EndComment}


Rules.
{Whitespace}     : skip_token.
{Css}            : {token, {directive_block, TokenLine, TokenChars}}.
.                : skip_token.

Erlang code.
