Definitions.

A = [a-zA-Z][a-zA-Z0-9_:@\-\.\s]*[a-zA-Z0-9]
D = -?[0-9]+
F = -?[0-9]+\.[0-9]+
S = [\s\t]

Rules.

= : {token,{'=',TokenLine}}.
\] : {token,{']',TokenLine}}.
{S}*\[ : {token,{'[',TokenLine}}.
{S}*{A}+{S}*\] : {token,{key,TokenLine,to_key(TokenChars,TokenLen)},"]"}.
{S}*{A}+{S}*= : {token,{key,TokenLine,to_key(TokenChars,TokenLen)},"="}.
{S}*{A}+ : {token,{value,TokenLine,to_binary(TokenChars)}}.
{S}*{D}+ : {token,{value,TokenLine,to_integer(TokenChars)}}.
{S}*{F}+ : {token,{value,TokenLine,to_float(TokenChars)}}.
{S}*".+" : {token,{value,TokenLine,to_binary(TokenChars)}}.
{S}*[^=\[;""\n]+ : {token,{value,TokenLine,to_binary(string:strip(TokenChars))}}.
;.* : skip_token.
[\000-\s]+ : skip_token.

Erlang code.

-compile({inline, to_key/2}).
to_key(TokenChars, TokenLen) ->
    S = string:substr(TokenChars, 1, TokenLen-1),
    K = string:strip(S),
    list_to_binary(K).

-compile({inline, to_binary/1}).
to_binary(TokenChars) ->
    list_to_binary(string:strip(TokenChars, left)).

-compile({inline, to_integer/1}).
to_integer(TokenChars) ->
    list_to_integer(string:strip(TokenChars, left)).

-compile({inline, to_float/1}).
to_float(TokenChars) ->
    list_to_float(string:strip(TokenChars, left)).
