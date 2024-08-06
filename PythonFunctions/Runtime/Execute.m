
enclose = Function[expr, Catch[expr, "ff27b3c7-720e-4922-bdaf-a48a35fe3a64"], HoldAllComplete]
confirm = Function[expr, Replace[expr, f_?FailureQ :> Throw[f, "ff27b3c7-720e-4922-bdaf-a48a35fe3a64"]]]

joinPythonLocation[args___] := FileNameJoin @ {
    PacletObject["PythonFunctions"]["AssetLocation", "Functions"],
    args
}

getPythonEnvironment[name_] := {
    "Python",
    "StandardErrorFunction" -> Null,
    "ID" -> "PythonFunctions" <> name,
    "Evaluator" -> <|
        "Dependencies" -> File @ joinPythonLocation[name, "requirements.txt"],
        "EnvironmentName" -> "WolframFunctions" <> name
    |>,
    "SessionProlog" -> {
        "import sys; sys.path.extend" -> {{
            PacletObject["PythonFunctions"]["AssetLocation", "Common"], 
            joinPythonLocation[name]}
        },
        "from function_handler import function_handler"
    }
}



(* 

    this is the main function used to call python code 
    it takes to argument the environment name and the entrypoint

    - environment name is the name of the folder Python/Environments/{{ name }}
    - entry point is the python import path of the module

    Calling executePythonEntrypoint["Science", "Kepler"] will create an environment named "Science", using the requirement file under Python/Environment/Science/requirements.txt

    After that it will run the python code under Python/Environment/Science/Kepler.py that will be passed to the optional custom function in the third argument.

*)

Options[executePythonEntrypoint] := {
    "ReturnType" -> "Expression",
    "Validate" -> True,
    "KeepOpen" -> True
}

executePythonEntrypoint[name_String, entry_List, handler_: Function[#1], OptionsPattern[]] :=
    enclose @ With[
        {session = confirm @ StartExternalSession @ getPythonEnvironment @ name},
        WithCleanup[
            handler[
                confirm /@ confirm @ ExternalEvaluate[
                    session, 
                    Map[
                        <|
                            "Command" -> "function_handler",
                            "Arguments" -> {#, "validate_call" -> OptionValue["Validate"]},
                            "ReturnType" -> OptionValue["ReturnType"]
                        |> &,
                        entry
                    ]
                ],
                session
            ],

            If[
                TrueQ[OptionValue["KeepOpen"]],
                Null,
                DeleteObject[session]
            ]
        ]
    ]

executePythonEntrypoint[name_String, entry_String, handler_: Function[#1], rest___] := 
    executePythonEntrypoint[
        name, 
        {entry}, 
        Function[handler[First[#1], #2]], 
        rest
    ]

executePythonEntrypoint[name_String, entry_Association, handler_: Function[#1], rest___] := 
    executePythonEntrypoint[
        name, 
        Values[entry], 
        Function[handler[AssociationThread[Keys[entry] -> #1], #2]], 
        rest
    ]
