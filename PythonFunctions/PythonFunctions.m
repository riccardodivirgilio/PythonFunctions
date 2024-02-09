(* 
    This file loaded by Get/Needs["ExternalEvaluate`"]. 
    It must load the package files and also ensure that ExternalEvaluate` context is on $ContextPath, which is not done by ExternalEvaluateLoader.
*)

BeginPackage["PythonFunctions`"]
EndPackage[]



PacletManager`Package`loadWolframLanguageCode[
    "PythonFunctions", 
    "PythonFunctions`", 
    DirectoryName[$InputFileName], 
    "PythonFunctionsLoader.m",
    "AutoUpdate"       -> True, 
    "ForceMX"          -> False, 
    "Lock"             -> False,
    "AutoloadSymbols"  -> {},
    "SymbolsToProtect" -> {}
]