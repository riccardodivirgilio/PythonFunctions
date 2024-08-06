
PythonFunctions`PythonFunction

processData[data_List, rest___] := Map[processData[#, rest] &, data]
processData[data_Association, funcs___] := Fold[Append[#1, #2[#1]] &, data, Flatten @ {funcs}]


discoverExtensions[] := Module[
    {i = 0},
    Flatten @ Map[
        Function @ Cases[
            #["Extensions"], 
            {"PythonFunctions", rules___} :> <|
                
                "Namespace" -> #["Name"], 
                "Root" -> "PythonFunctions",
                "Evaluator" -> <||>,
                rules,
                "Location" -> #["Location"],
                "ID" -> ++i
            |>
        ],
        PacletFind[]
    ]
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

    (* validation step, we need to make sure filenames are not full of garbage *)
    Function[
        Scan[
            Function @ KeyValueMap[
                Function[
                    {lang, paths},
                    If[
                        Length[paths] =!= 1, 
                        confirm @ Failure[
                            "ImproperlyConfigured", <|
                                "Paths" -> #,
                                "MessageTemplate" -> "The function `Function` has not been declared `Count` times in `Language`", 
                                "MessageParameters" -> <|
                                    "Function" -> FileBaseName @ First @ First @ #,
                                    "Count" -> Length[paths],
                                    "Language" -> lang
                                |>
                            |>
                        ]
                    ]
                ],
                <|"Python" -> {}, #|>
            ],
            #Functions
        ];
        {}
    ],

    (* adding namespace in all functions *)

    Function[
        "Functions" -> Map[
            Function[
                info, <|
                    "Namespace" -> #Namespace, 
                    Replace[
                        Lookup[info, "WL"], {
                            {s_String} :> "Processor" :> Get[s],
                            _ :> "Processor" -> Identity
                        }
                    ],
                    "File" -> File[info[["Python", 1]]]


                |>
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


PythonFunction::notunique = "The function `` appears in multiple namespaces, it was selected the one from `` namespace"

PythonFunction[] := Keys[functionLibrary[]]
PythonFunction[func_String, rest___] := 
    enclose @ Replace[
        Echo[functionLibrary[]][func],
        {
            _Missing :> confirm @ Failure[
                "MissingFunction",
                <|
                    "MessageTemplate" -> "Invalid function `Function`",
                    "MessageParameters" -> <|
                        "Function" -> func
                    |>,
                    "Choices" -> PythonFunction[]
                |>
            ],
            assoc_Association :> With[
                {namespace = First @ Keys @ assoc},
                If[
                    Length[Echo@assoc] > 1,
                    Message[PythonFunction::notunique, func, namespace]
                ];

                PythonFunction[{namespace, func}]


            ]
        }
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