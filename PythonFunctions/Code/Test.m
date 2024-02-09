PythonFunctions`TestAddTwo
PythonFunctions`TestDouble
PythonFunctions`TestDispatch

(* sample input "Kepler-10" *)
TestAddTwo[n_Integer] := 
    executePythonEntrypoint[
        "Test", 
        "AddTwo", 
        Function[{session, func}, func[n]]
    ]


(* sample input "Kepler-10" *)
TestDouble[n_Integer] := 
    executePythonEntrypoint[
        "Test", 
        "Double", 
        Function[{session, func}, func[n]]
    ]

(* sample input "Kepler-10" *)
TestDispatch[name_String, n_Integer] := 
    executePythonEntrypoint[
        "Test", 
        "Dispatch", 
        Function[{session, func}, func[name, n]]
    ]