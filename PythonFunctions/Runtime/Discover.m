
PythonFunctions`PythonFunction

processData[data_List, rest___] := Map[processData[#, rest] &, data]
processData[data_Association, funcs___] := Fold[Append[#1, #2[#1]] &, data, Flatten @ {funcs}]


discoverExtensions[] :=
    Flatten @ Map[
        Function @ Cases[
            #["Extensions"], 
            {"PythonFunctions", rules___} :> <|
                
                "Namespace" -> #["Name"], 
                "Root" -> "PythonFunctions",
                "Evaluator" -> <||>,
                rules,
                "Location" -> #["Location"]
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
    (* creating paclet absolute path *)
    Function[
        "AbsolutePath" -> FileNameJoin @ {#Location, #Root}
    ],
    (* search for all python files and wl files in the directory, grouped by file type *)
    Function[
        "Functions" -> GroupBy[
            FileNames[{"*.py", "*.m", "*.wl"}, #AbsolutePath, Infinity],
            {FileBaseName, Function[If[FileExtension[#] == "py", "Python", "WL"]]}
        ]
    ],


    (* adding namespace in all functions *)

    Function[
        "Functions" -> Map[
            Function[
                info, Join[
                    info, 
                    KeyDrop[#, {"Functions", "Root", "Location", "AbsolutePath"}]
                ]
            ],
            #Functions
        ]
    ]
]


functionLibrary[] := KeySort @ Merge[
    processExtensions[][[All, "Functions"]],
    Function @ GroupBy[#, Key["Namespace"]]
]





relativeFileNames[ext_, base_, rest___] :=
    With[
        {len = Length[FileNameSplit[base]]},
        Map[
            FileNameDrop[#, {1, len}] &,
            FileNames[ext, base, rest]
        ]
    ]

$pythonFunctions := $pythonFunctions = Association @ Apply[
    FileBaseName[#2] -> #1 &,
    FileNameSplit /@ relativeFileNames["*.py", joinPythonLocation[], Infinity],
    {1}
]


Options[PythonFunction] = Options[executePythonEntrypoint]


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

PythonFunction[] := Keys[functionLibrary[]]
PythonFunction[func_String, rest___][args___] := 
    enclose @ Replace[
        functionLibrary[][[func]],
        {
            _Missing :> missingFunctionError[func],
            assoc_Association :> With[
                {namespace = First @ Keys @ assoc},
                If[
                    Length[assoc] > 1,
                    Message[PythonFunction::notunique, func, namespace]
                ];
                PythonFunction[{namespace, func}][args]
            ]
        }
    ]



PythonFunction[{namespace_, func_}, opts:OptionsPattern[]][args___] := 
    enclose @ With[
        {
            info = Replace[
                functionLibrary[][[func, namespace]],
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
            callPythonFunction = List
        },

        Replace[
            Lookup[info, {"Python", "WL"}, {}], {
                {{p_}, {wl_}}  :> callPythonFunction[p, Get[wl]],
                {{p_}, {}}     :> callPythonFunction[p, Identity],
                {impl:{__}}    :> multipleImplementationError[func, namespace, impl],
                {_, impl:{__}} :> multipleImplementationError[func, namespace, impl]
            }
        ]
    ]


PythonFunction[{}, opts:OptionsPattern[]][args___] := enclose @ With[
    {
        module = Lookup[
            $pythonFunctions, 
            func, 
            confirm @ Failure["NotAFunction"]
        ]
    },
    executePythonEntrypoint[module, func <> "." <> func, Function[#[args]], opts]
]


