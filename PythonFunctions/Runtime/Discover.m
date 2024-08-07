
PythonFunctions`PythonFunction

processData[data_List, rest___] := Map[processData[#, rest] &, data]
processData[data_Association, funcs___] := Fold[Append[#1, #2[#1]] &, data, Flatten @ {funcs}]


discoverExtensions[] :=
    Flatten @ Map[
        Function @ Cases[
            #["Extensions"], 
            {"PythonFunctions", rules___} :> <|
                
                "Namespace"        -> #["Name"], 
                "ID"               -> "PythonFunctions" <> #["Name"],
                "Root"             -> "PythonFunctions",
                "Needs"            -> {},
                "Functions"        -> {},
                "Handlers"         -> {},
                "Evaluator"        -> <||>,
                "ImportPaths"      -> {},
                "ProcessDirectory" -> "",
                rules,
                "Location"         -> #["Location"]
            |>
        ],
        PacletFind[]
    ]

processExtensions[] := processData[
    discoverExtensions[],

    (* patching evaluator with defaults, if no depedencies is specified we lookup for a requirement.txt in the root *)

    Function[
        If[
            AssociationQ[#Evaluator],
            "Evaluator" -> <|
                "EnvironmentName" -> #Namespace,                     
                "Dependencies" -> File @ FileNameJoin @ {#Location, #Root, "requirements.txt"}, 
                #Evaluator
            |>,
            {}
        ]
    ],
    (* creating absolute paths *)
    Function[{
        "AbsolutePath" -> FileNameJoin @ {#Location, #Root},
        "ImportPaths" -> Map[
            Function[p, FileNameJoin @ {#Location, p}],
            Flatten @ {#ImportPaths}
        ],
        "ProcessDirectory" -> FileNameJoin @ {#Location, #ProcessDirectory}
    }],



    (* search for all python files and wl files in the directory, grouped by file type *)
    Function[
        "AllFunctions" -> Merge[{
            GroupBy[
                FileNames[{"*.py", "*.m", "*.wl"}, #AbsolutePath, Infinity],
                {FileBaseName, Function[If[FileExtension[#] == "py", "Python", "WL"]]},
                Map[File]
            ],
            Map[
                <|"Python" -> Fold[
                    ExternalOperation["GetAttribute", ##] & , 
                    MapAt[ExternalOperation["Import", ##] &, Flatten[#], {1}]
                ]|> &,
                <|#Functions|>
            ],
            Map[
                <|"WL" -> Symbol[#]|> &,
                <|#Handlers|>
            ]
        },
        Merge[{##}, Join] &
    ]],


    (* adding namespace in all functions *)

    Function[
        "AllFunctions" -> Map[
            Function[
                info, Join[
                    info, 
                    KeyDrop[#, {
                        "AllFunctions", "Root", "Location", "AbsolutePath",
                        "Handlers", "Functions"
                    }]
                ]
            ],
            #AllFunctions
        ]
    ]
]


functionLibrary[] := KeySort @ Merge[
    processExtensions[][[All, "AllFunctions"]],
    Function @ GroupBy[#, Key["Namespace"]]
]


$libraryCache := $libraryCache = functionLibrary[]

lookupLibrary[part___] := Replace[
    Part[$libraryCache, part], 
    _Missing :> (
        $libraryCache := $libraryCache = functionLibrary[];
        Part[$libraryCache, part]
    )
]




Options[PythonFunction] := Options[executePythonOperation]


(* failure modes *)

missingFunctionError[func_] := confirm @ Failure[
    "MissingFunction",
    <|
        "MessageTemplate" -> "Invalid function `Function`",
        "MessageParameters" -> <|
            "Function" -> func
        |>,
        "Choices" -> PythonFunction[]
    |>
]

missingFunctionError[func_, namespace_] := confirm @ Failure[
    "MissingFunction",
    <|
        "MessageTemplate" -> "Invalid function `Function` for namespace `Namespace`",
        "MessageParameters" -> <|
            "Function" -> func,
            "Namespace" -> namespace
        |>
    |>
]

multipleImplementationError[func_, namespace_, implementations_] := confirm @ Failure[
    "ImproperlyConfigured",
    <|
        "MessageTemplate" -> "The function `Function` doesn't have a single implementation for namespace `Namespace`",
        "MessageParameters" -> <|
            "Function" -> func,
            "Namespace" -> namespace
        |>,
        "Implementations" -> implementations
    |>
]




PythonFunction::notunique = "The function `` appears in multiple namespaces, it was selected the one from `` namespace"

PythonFunction[] := 
    Sort @ DeleteDuplicates[Join @@ KeyValueMap[
        Function[{name, spaces}, KeyValueMap[{#1, name} &, spaces]],
        lookupLibrary[]
    ]]

PythonFunction[func_String, rest___][args___] := 
    enclose @ Replace[
        lookupLibrary[func],
        {
            _Missing :> missingFunctionError[func],
            assoc_Association :> With[
                {namespace = First @ Keys @ assoc},
                If[
                    Length[assoc] > 1,
                    Message[PythonFunction::notunique, func, namespace]
                ];
                PythonFunction[{namespace, func}, rest][args]
            ]
        }
    ]



PythonFunction[{namespace_, func_}, opts:OptionsPattern[]][args___] := 
    enclose @ With[
        {
            info = Replace[
                lookupLibrary[func, namespace],
                {
                    _Missing :> missingFunctionError[func, namespace],
                    {one_} :> one,
                    s_List :> multipleImplementationError[
                        func, namespace, 
                        Flatten[s[[All, "Python"]]]
                    ]
                }
            ]
        },
        {
            options = Sequence @@ Flatten @ {
                Normal @ KeyDrop[info, {"Python", "WL", "Namespace"}],
                opts
            }
        },
        {
            callPythonFunction = Function[
                {file, handler},
                executePythonOperation[
                    ExternalObject["Python", file], 
                    Function[
                        handler @ <|
                            "Command" -> #1, 
                            "Session" -> #2,
                            "Arguments" -> {args}
                        |>
                    ], 
                    options
                ]
            ]
        },

        Replace[
            Lookup[info, {"Python", "WL"}, {}], {
                {{p_}, {wl_String}} :> callPythonFunction[p, Get[wl]],
                {{p_}, {wl_}}  :> callPythonFunction[p, wl],
                {{p_}, {}}     :> callPythonFunction[p, Function[ExternalEvaluate[#Session, #Command -> #Arguments]]],
                {impl:{__}}    :> multipleImplementationError[func, namespace, impl],
                {_, impl:{__}} :> multipleImplementationError[func, namespace, impl]
            }
        ]
    ]

