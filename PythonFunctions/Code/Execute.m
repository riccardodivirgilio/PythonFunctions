
(* 

    this is the main function used to call python code 
    it takes to argument the environment name and the entrypoint

    - environment name is the name of the folder Python/Environments/{{ name }}
    - entry point is the python import path of the module

    Calling executePythonEntrypoint["Science", "Kepler"] will create an environment named "Science", using the requirement file under Python/Environment/Science/requirements.txt

    After that it will run the python code under Python/Environment/Science/Kepler.py that will be passed to the optional custom function in the third argument.

*)

executePythonEntrypoint[name_String, entry_List, handler_: Function[#2]] :=
    enclose @ With[
        {session = confirm @ StartExternalSession @ getPythonEnvironment @ name},
        WithCleanup[
            handler[
                session,
                confirm @ ExternalEvaluate[
                    session, 
                    Map[
                        <|
                            "Command" -> "wolfram_import_string",
                            "Arguments" -> #,
                            "ReturnType" -> "ExternalObject"
                        |> &,
                        entry
                    ]
                ]
            ],
            DeleteObject[session]
        ]
    ]

executePythonEntrypoint[name_String, entry_String, handler_: Function[#2]] := 
    executePythonEntrypoint[name, {entry}, Function[handler[#1, First[#2]]]]

executePythonEntrypoint[name_String, entry_Association, handler_: Function[#2]] := 
    executePythonEntrypoint[name, Values[entry], Function[handler[#1, AssociationThread[Keys[entry] -> #2]]]]


