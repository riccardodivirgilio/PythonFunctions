
(* 

    this is the main function used to call python code 
    it takes to argument the environment name and the entrypoint

    - environment name is the name of the folder Python/Environments/{{ name }}
    - entry point is the python import path of the module

    Calling executePythonEntrypoint["Science", "Kepler"] will create an environment named "Science", using the requirement file under Python/Environment/Science/requirements.txt

    After that it will run the python code under Python/Environment/Science/Kepler.py that will be passed to the optional custom function in the third argument.

*)

executePythonEntrypoint[name_String, entry_List, handler_: Function[#2]] :=
    enclose @ With[
        {session = confirm @ StartExternalSession @ getPythonEnvironment @ name},
        WithCleanup[
            handler[
                session,
                confirm @ ExternalEvaluate[
                    session, 
                    Map[
                        <|
                            "Command" -> "wolfram_import_string",
                            "Arguments" -> #,
                            "ReturnType" -> "ExternalObject"
                        |> &,
                        entry
                    ]
                ]
            ],
            DeleteObject[session]
        ]
    ]

executePythonEntrypoint[name_String, entry_String, handler_: Function[#2]] := 
    executePythonEntrypoint[name, {entry}, Function[handler[#1, First[#2]]]]

executePythonEntrypoint[name_String, entry_Association, handler_: Function[#2]] := 
    executePythonEntrypoint[name, Values[entry], Function[handler[#1, AssociationThread[Keys[entry] -> #2]]]]




(* create python function creates a wrapper for a single entrypoint and automatically adds options *)

$inspectCode = "

import inspect

def make_inspection(func):
    sig = inspect.signature(func)

    kind = {
        getattr(inspect.Parameter, attr): attr
        for attr in (
            'POSITIONAL_ONLY',      
            'POSITIONAL_OR_KEYWORD',
            'VAR_POSITIONAL',       
            'KEYWORD_ONLY',         
            'VAR_KEYWORD',  
        )        
    }

    return {'Parameters': {n: {'Kind': kind[p.kind]} for n, p in sig.parameters.items()}}

"


SetAttributes[createPythonFunction, HoldFirst]

createPythonFunction[symbol_, name_String, entry_String] := enclose @ Module[
    {
        informations = executePythonEntrypoint[
            name, 
            entry, 
            Function[{session, obj}, ExternalEvaluate[session, $inspectCode -> obj]]
        ],
        positional
    },

    ClearAll[symbol];

    Cases[
        informations["Parameters"], 
        a:KeyValuePattern["Kind" -> "VAR_POSITIONAL"|"VAR_KEYWORD"] 
            :> confirm @ Failure["NotSupported",  <|
                  "MessageTemplate" -> "Parameter signature `Sig` is not supported yet",
                  "MessageParameters" -> <|"Sig" -> a|>
                  |>
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
                    Apply[
                        obj,
                        Join[{"Call"}, pos, kwargs]
                    ]
                ]
            ]
        }
    ];

    symbol

]


