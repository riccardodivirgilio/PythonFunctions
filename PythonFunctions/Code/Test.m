PythonFunctions`TestAddTwo
PythonFunctions`TestDouble
PythonFunctions`TestDispatch

(* sample input TestAddTwo[12] *)
TestAddTwo[n_Integer] := 
    executePythonEntrypoint[
        "Test", 
        "AddTwo", 
        Function[{session, func}, func[n]]
    ]


(* sample input TestDouble[23] *)
TestDouble[n_Integer] := 
    executePythonEntrypoint[
        "Test", 
        "Double", 
        Function[{session, func}, func[n]]
    ]

(* sample input TestDispatch["add_two", 2] *)
TestDispatch[name_String, n_Integer] := 
    executePythonEntrypoint[
        "Test", 
        "Dispatch", 
        Function[{session, func}, func[name, n]]
    ]