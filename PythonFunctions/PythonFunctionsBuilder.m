
BeginPackage["PythonFunctionsBuilder`"]

Begin["`Private`"]


Scan[
    Scan[
        Get,
        FileNames[
            "*.m", 
            FileNameJoin @ {DirectoryName @ $InputFileName, #}
        ]
    ] &,
    {"Builder"}
]


End[] 

EndPackage[]