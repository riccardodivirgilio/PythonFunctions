PythonFunctions`KeplerLightCurves

(* sample input "Kepler-10" *)
KeplerLightCurves[obj_String] := 
    executePythonEntrypoint[
        "Science", 
        "kepler.entrypoint", 
        Function[
            {session, func},
            Map[TimeSeries[Transpose[Normal[#]]]&, func[obj]]
        ]
    ]
