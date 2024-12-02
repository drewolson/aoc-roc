module [transpose]

transpose : List (List a) -> List (List a)
transpose = \matrix ->
    aux = \m, acc ->
        when List.mapTry m List.first is
            Ok firsts ->
                m
                |> List.map \l -> List.dropFirst l 1
                |> aux (List.append acc firsts)

            _ -> acc

    matrix |> aux []
