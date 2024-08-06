
enclose = Function[expr, Catch[expr, "ff27b3c7-720e-4922-bdaf-a48a35fe3a64"], HoldAllComplete]
confirm = Function[expr, Replace[expr, f_?FailureQ :> Throw[f, "ff27b3c7-720e-4922-bdaf-a48a35fe3a64"]]]

joinPythonLocation[args___] := FileNameJoin @ {
    PacletObject["PythonFunctions"]["AssetLocation", "Functions"],
    args
}


Options[executePythonFile] := {
    "ID" -> Automatic,
    "ReturnType" -> "Expression",
    "Validate" -> True,
    "KeepOpen" -> False,
    "StandardErrorFunction" -> Automatic,
    "StandardOutputFunction" -> Automatic,
    "Evaluator" -> <||>
}


executePythonFile[file_String, handler_: Function[#1], OptionsPattern[]] := 
    enclose @ With[
        {session = confirm @ StartExternalSession @ {
            "Python",
            "StandardErrorFunction" -> OptionValue["StandardErrorFunction"],
            "ID"                    -> OptionValue["ID"],
            "Evaluator"             -> OptionValue["Evaluator"],
            "ReturnType"            -> OptionValue["ReturnType"],
            "SessionProlog"         -> {

                "import sys; sys.path.extend" -> {{
                    PacletObject["PythonFunctions"]["AssetLocation", "Common"]
                }}

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
