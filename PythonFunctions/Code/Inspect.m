(* create python function creates a wrapper for a single entrypoint and automatically adds options *)

SetAttributes[createPythonFunction, HoldFirst]

createPythonFunction[symbol_, name_String, entry_String, handler_: Function[#2]] := enclose @ Module[
    {informations, positional},

    ClearAll[symbol];

    informations = confirm @ executePythonEntrypoint[
        name, 
        <|
            "Target" -> entry,
            "Inspector" -> "inspector.inspect_function"
        |>, 
        Function[
            {session, obj}, 
            ExternalEvaluate[session, obj["Inspector"] -> obj["Target"]]
        ]
    ];

    Options[symbol] = KeyValueMap[
        #1 -> None &,
        Select[informations["Parameters"], MemberQ[{"POSITIONAL_OR_KEYWORD", "KEYWORD_ONLY"}, #Kind] &]
    ];

    positional = Select[informations["Parameters"], MemberQ[{"POSITIONAL_ONLY"}, #Kind] &];

    symbol[args___, opts:OptionsPattern[]] := Replace[
        System`Private`ArgumentsWithRules[symbol[args, opts], Length[positional]],
        {
            {} -> Failure["InvalidArguments"],
            {pos_, kwargs_} :> executePythonEntrypoint[
                name, entry, 
                Function[
                    {session, obj}, 
                    handler[
                        session,
                        confirm @ Apply[
                            obj,
                            Join[{"Call"}, pos, kwargs]
                        ]
                    ]
                ]
            ]
        }
    ];

    symbol

]


