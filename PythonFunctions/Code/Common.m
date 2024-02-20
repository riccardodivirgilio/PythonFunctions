
enclose = Function[expr, Catch[expr, "ff27b3c7-720e-4922-bdaf-a48a35fe3a64"], HoldAllComplete]
confirm = Function[expr, Replace[expr, f_?FailureQ :> Throw[f, "ff27b3c7-720e-4922-bdaf-a48a35fe3a64"]]]

joinPythonLocation[args___] := FileNameJoin @ {
    PacletObject["PythonFunctions"]["AssetLocation", "Python"],
    args
}

getPythonEnvironment[name_] := {
    "Python",
    "StandardErrorFunction" -> Null,
    "ProcessDirectory" -> joinPythonLocation[name],
    "Evaluator" -> <|
        "Dependencies" -> File @ joinPythonLocation[name, "requirements.txt"],
        "EnvironmentName" -> "Wolfram" <> name
    |>,
    "SessionProlog" -> "from wolframclient.utils.importutils import import_string as wolfram_import_string"
}
