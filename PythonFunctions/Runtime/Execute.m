
enclose = Function[expr, Catch[expr, "ff27b3c7-720e-4922-bdaf-a48a35fe3a64"], HoldAllComplete]
confirm = Replace[fail_?FailureQ :> Throw[fail, "ff27b3c7-720e-4922-bdaf-a48a35fe3a64"]]

joinPythonLocation[args___] := FileNameJoin @ {
    PacletObject["PythonFunctions"]["AssetLocation", "Functions"],
    args
}


Options[executePythonFile] := {
    "ID"                     -> Automatic,
    "ReturnType"             -> "Expression",
    "Validate"               -> True,
    "KeepOpen"               -> False,
    "StandardErrorFunction"  -> Automatic,
    "StandardOutputFunction" -> Automatic,
    "ProcessDirectory"       -> Automatic,
    "ProcessEnvironment"     -> Automatic,
    "Prolog"                 -> {}, 
    "SessionProlog"          -> {},
    "Epilog"                 -> {}, 
    "SessionEpilog"          -> {},
    "Evaluator"              -> <||>,
    "ImportPaths"            -> {}
}


executePythonFile[file_String, handler_: Function[#2], OptionsPattern[]] := 
    enclose @ With[
        {session = confirm @ StartExternalSession @ {
            "Python",
            "StandardErrorFunction"  -> OptionValue["StandardErrorFunction"],
            "ID"                     -> OptionValue["ID"],
            "Evaluator"              -> OptionValue["Evaluator"],
            "ReturnType"             -> OptionValue["ReturnType"],
            "StandardErrorFunction"  -> OptionValue["StandardErrorFunction"],
            "StandardOutputFunction" -> OptionValue["StandardOutputFunction"],
            "ProcessDirectory"       -> OptionValue["ProcessDirectory"],
            "ProcessEnvironment"     -> OptionValue["ProcessEnvironment"],
            "Epilog"                 -> OptionValue["Epilog"],
            "SessionEpilog"          -> OptionValue["SessionEpilog"],
            "Prolog"                 -> OptionValue["Prolog"],
            "SessionProlog"          -> Flatten @ {
                "import sys; sys.path.extend" -> {Flatten @ {
                    PacletObject["PythonFunctions"]["AssetLocation", "Common"],
                    OptionValue["ImportPaths"]
                }},
                OptionValue["SessionProlog"]
            }
        }},
        WithCleanup[
            handler[
                confirm @ ExternalEvaluate[
                    session, <|
                        "Command" -> ExternalOperation["Import", "function_handler", "function_handler"],
                        "Arguments" -> {
                            ExternalObject["Python", File[file]], 
                            "validate_call" -> OptionValue["Validate"]
                        }
                    |>
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
