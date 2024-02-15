
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
    |>
}

(* 

    this is the main function used to call python code 
    it takes to argument the environment name and the entrypoint

    - environment name is the name of the folder Python/Environments/{{ name }}
    - entry point is the python import path of the module

    Calling executePythonEntrypoint["Science", "Kepler"] will create an environment named "Science", using the requirement file under Python/Environment/Science/requirements.txt

    After that it will run the python code under Python/Environment/Science/Kepler.py that will be passed to the optional custom function in the third argument.

*)

executePythonEntrypoint[name_String, entry_String, rest___] :=
    enclose @ executePythonEntrypoint[
        name,
        confirm @ Replace[
            StringSplit[entry, "."], 
            {
                {pre__, post_} :> {StringRiffle[{pre}, "."], post},
                _ :> Failure["InvalidPath"]
            }
        ],
        rest
    ]
executePythonEntrypoint[name_String, {module_String, attr_String}, handler_: Function[#2]] :=
    enclose @ With[
        {session = confirm @ StartExternalSession @ getPythonEnvironment @ name},
        WithCleanup[
            handler[
                session,
                confirm @ ExternalEvaluate[
                    session, 
                    <|
                        "Command" -> "lambda module, attr: getattr(__import__(module), attr)",
                        "Arguments" -> {module, attr},
                        "ReturnType" -> "ExternalObject"
                    |>
                ]
            ],
            DeleteObject[session]
        ]
    ]