PythonFunctions`TestAddTwo
PythonFunctions`TestDouble
PythonFunctions`TestDispatch

(* sample input TestAddTwo[12] *)
TestAddTwo[n_Integer] := 
    executePythonEntrypoint[
        "Test", 
        "add_two.run_add_two", 
        Function[{session, func}, func[n]]
    ]


(* sample input TestDouble[23] *)
TestDouble[n_Integer] := 
    executePythonEntrypoint[
        "Test", 
        "double.run_double", 
        Function[{session, func}, func[n]]
    ]

(* sample input TestDispatch["add_two", 2] *)
TestDispatch[name_String, n_Integer] := 
    executePythonEntrypoint[
        "Test", 
        "dispatch.dispatch_method", 
        Function[{session, func}, func[name, n]]
    ]