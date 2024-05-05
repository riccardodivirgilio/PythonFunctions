
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
    {"Runtime"}
]


End[] 

EndPackage[]