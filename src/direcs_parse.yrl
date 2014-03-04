Nonterminals
  value object array value_list name_val_pair_list.
Terminals
  NUMBER STRING '{' '}' ',' ':' '[' ']' 'true' 'false' 'null'.

Rootsymbol value.

%Endsymbol '$end'. %(optional)

% operator precedence (optional)
% Right 100 '='.
% Nonassoc 200 '==' '=/='.
% Left 300 '+'.
% Left 400 '*'.
% Unary 500 '-'. 
% grammer rules
value -> STRING : unwrap
('$1').
value -> NUMBER : unwrap
('$1').
value -> 'true' : 'true'.
value -> 'false' : 'false'.
value -> 'null' : 'null'.
value -> object : '$1'.
value -> array : '$1'.
array -> '[' value_list ']' : '$2'.
object -> '{' name_val_pair_list '}' : '$2'.
name_val_pair_list -> STRING ':' value : 
[{list_to_atom(unwrap_to_string('$1')), '$3'}].
name_val_pair_list -> STRING ':' value ',' name_val_pair_list : 
[{list_to_atom(unwrap_to_string('$1')), '$3'}|'$5'].
value_list -> '$empty' : [].
value_list -> value : ['$1'].
value_list -> value_list ',' value : '$1' ++ 
['$3'].

Erlang code.
unwrap({_,_,X}) -> X.
unwrap_to_string({_,_,X}) -> binary_to_list(X).
