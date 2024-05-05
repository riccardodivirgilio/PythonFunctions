
PythonFunctions`PythonFunction

discoverPythonFunctions[] := Association @ Map[
    With[
        {entry = #FunctionName, name = Last[StringSplit[#FunctionName, "."]], path = #Path},
        name -> Function[executePythonEntrypoint[path, entry, Function[func, func[##]]]]
    ] &,
    Import[PacletObject["PythonFunctions"]["AssetLocation", "Manifest"]]
]

PythonFunction[] := Keys[discoverPythonFunctions[]]
PythonFunction[s_String][args___] := discoverPythonFunctions[][s][args]