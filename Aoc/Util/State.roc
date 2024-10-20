module [
    State,
    return,
    get,
    put,
    modify,
    do,
    run,
    eval,
]

State s a :=
    (s -> (a, s))

return : a -> State s a
return = \a ->
    @State (\s -> (a, s))

get :  State s s
get =
    @State \s -> (s, s)

put :  s -> State s {}
put = \s ->
    @State \_ -> ({}, s)

modify : (s -> s) -> State s {}
modify = \f ->
    @State \s -> ({}, f s)

do : State s a, (a -> State s b) -> State s b
do = \@State sa, f ->
    @State \s ->
        (a, s1) = sa s
        @State sb = f a
        sb s1

run : State s a, s -> (a, s)
run = \@State f, s ->
    f s

eval : State s a, s -> a
eval = \st, s ->
    (a, _) = run st s
    a
