
BeginPackage["PythonFunctions`"]

Begin["`Private`"]


Scan[
    Scan[
        Get,
        FileNames[
            "*.m", 
            FileNameJoin @ {DirectoryName @ $InputFileName, #}
        ]
    ] &,
    {"Code"}
]


End[] 

EndPackage[]