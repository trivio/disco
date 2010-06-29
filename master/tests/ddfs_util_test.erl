-module(ddfs_util_test).
-export([prop_test/0]).

-include_lib("proper/include/proper.hrl").

of_hex_helper(H, Int) ->
    case H of
        "" ->
            Int;
        [Hd|Tl] when (Hd >= $0) and (Hd =< $9) ->
            of_hex_helper(Tl, Int*16 + (Hd - $0));
        [Hd|Tl] when ((Hd >= $A) and (Hd =< $F)) ->
            of_hex_helper(Tl, Int*16 + 10 + (Hd - $A));
        [Hd|Tl] when ((Hd >= $a) and (Hd =< $f)) ->
            of_hex_helper(Tl, Int*16 + 10 + (Hd - $a));
        _ ->
            {'error', "invalid hex character"}
    end.

-spec of_hex(string()) -> integer() | {'error', string()}.
of_hex(H) ->
    of_hex_helper(H, 0).


prop_inttoint() ->
    ?FORALL(Val, non_neg_integer(), Val == of_hex(ddfs_util:to_hex(Val))).

prop_test() ->
    proper:check(prop_inttoint()).
