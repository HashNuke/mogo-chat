Nonterminals
  directive_list directives.

Terminals
  directive start_comment end_comment.

Rootsymbol directive_list.

directive_list -> start_comment directives end_comment : '$2'.
directives -> directive directives : ['$1' | '$2'].
directives -> directive : '$1'.

Erlang code.
