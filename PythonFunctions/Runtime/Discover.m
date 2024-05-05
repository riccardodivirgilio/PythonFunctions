
PythonFunctions`PythonFunction

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

PythonFunction[] := Keys[$pythonFunctions]
PythonFunction[func_String][args___] := enclose @ With[
    {
        module = Lookup[
            $pythonFunctions, 
            func, 
            confirm @ Failure["NotAFunction"]
        ]
    },
    executePythonEntrypoint[module, func <> "." <> func, Function[#[args]]]
]