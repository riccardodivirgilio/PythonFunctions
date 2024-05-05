
enclose = Function[expr, Catch[expr, "ff27b3c7-720e-4922-bdaf-a48a35fe3a64"], HoldAllComplete]
confirm = Function[expr, Replace[expr, f_?FailureQ :> Throw[f, "ff27b3c7-720e-4922-bdaf-a48a35fe3a64"]]]



findFunctionName[paths_] := ExternalEvaluate[
    {
        "Python", 
        "Evaluator" -> <|"Dependencies" -> {}, "EnvironmentName" -> "WolframFunctionsBuilder"|>,
        "ProcessDirectory" -> PacletObject["PythonFunctions"]["AssetLocation", "Common"],
        "SessionProlog" -> "from inspector import get_function_name; import os"
    },
    "lambda base, paths: tuple(get_function_name(os.path.join(base, p)) for p in paths)" -> {
        joinFunctionsLocation[], 
        paths
    }
]



relativeFileNames[ext_, base_, rest___] :=
    With[
        {len = Length[FileNameSplit[base]]},
        Map[
            FileNameDrop[#, {1, len}] &,
            FileNames[ext, base, rest]
        ]
    ]


joinFunctionsLocation[args___] := FileNameJoin @ {
    PacletObject["PythonFunctions"]["AssetLocation", "Functions"],
    args
}

buildPythonFunctions[] := 
    enclose @ With[
        {paths = relativeFileNames["*.py", joinFunctionsLocation[], Infinity]},
        Transpose[
            <|
                "Path" -> Map[DirectoryName, paths],
                "FunctionName" -> confirm @ findFunctionName[paths]
            |>,
            AllowedHeads -> All
        ]
    ]

savePythonManifest[] := 
    enclose @ Export[
        PacletObject["PythonFunctions"]["AssetLocation", "Manifest"],
        confirm @ buildPythonFunctions[]
    ]


