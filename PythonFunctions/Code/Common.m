
enclose = Function[expr, Catch[expr, "ff27b3c7-720e-4922-bdaf-a48a35fe3a64"], HoldAllComplete]
confirm = Function[expr, Replace[expr, f_?FailureQ :> Throw[f, "ff27b3c7-720e-4922-bdaf-a48a35fe3a64"]]]

joinPythonLocation[args___] := FileNameJoin @ {
    PacletObject["PythonFunctions"]["AssetLocation", "Python"],
    args
}

getPythonEnvironment[name_] := {
    "Python",
    "StandardErrorFunction" -> Null,
    (* "ProcessDirectory" -> joinPythonLocation["Code"], *)
    "Evaluator" -> <|
        "Dependencies" -> File @ joinPythonLocation["Environments", name, "requirements.txt"],
        "EnvironmentName" -> "Wolfram" <> name
    |>
}

executePythonEntrypoint[name_, entry_, handler_: Function[#2]] :=
    enclose @ Module[
        {session, object},
        session = confirm @ StartExternalSession[getPythonEnvironment[name]];
        WithCleanup[
            handler[
                session,
                confirm @ ExternalEvaluate[
                    session, 
                    File @ joinPythonLocation["Environments", name, entry <> ".py"]
                ]
            ],
            DeleteObject[session]
        ]
    ]