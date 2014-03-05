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

SingleLineComment = (//|\#)

CssBlock = {StartComment}{OptWhitespace}(\**{OptWhitespace}\={OptWhitespace}{DirectiveLine}{OptWhitespace})+{EndComment}
JsBlock = ({SingleLineComment}{OptWhitespace}={OptWhitespace}{DirectiveLine}{Whitespace})+

CommentBlock = ({CssBlock}|{JsBlock})


Rules.
{Whitespace}   : skip_token.
{CommentBlock} : {token, {directive_block, TokenLine, TokenChars}}.
.              : skip_token.

Erlang code.
