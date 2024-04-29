PythonFunctions`TestAddTwo
PythonFunctions`TestDouble
PythonFunctions`TestDispatch

(* sample input TestAddTwo[12] *)
TestAddTwo[n_Integer] := 
    executePythonEntrypoint[
        "Test", 
        "add_two.run_add_two", 
        Function[{func, session}, func[n]]
    ]


(* sample input TestDouble[23] *)
TestDouble[n_Integer] := 
    executePythonEntrypoint[
        "Test", 
        "double.run_double", 
        Function[{func, session}, func[n]]
    ]

(* sample input TestDispatch["add_two", 2] *)
TestDispatch[name_String, n_Integer] := 
    executePythonEntrypoint[
        "Test", 
        "dispatch.api", 
        Function[{func, session}, func[name, n]]
    ]