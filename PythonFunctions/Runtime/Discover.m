
PythonFunctions`PythonFunction

$pythonFunctions := $pythonFunctions = Association @ Map[
    With[
        {entry = #FunctionName, name = Last[StringSplit[#FunctionName, "."]], path = #Path},
        name -> Function[executePythonEntrypoint[path, entry, Function[func, func[##]]]]
    ] &,
    Import[PacletObject["PythonFunctions"]["AssetLocation", "Manifest"]]
]

PythonFunction[] := Keys[$pythonFunctions]
PythonFunction[s_String][args___] := $pythonFunctions[s][args]