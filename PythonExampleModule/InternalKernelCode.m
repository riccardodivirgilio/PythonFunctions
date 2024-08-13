
BeginPackage["InternalKernelCode`"]

Begin["`Private`"]

execute = Function[ExternalEvaluate[#Session, #Command -> #Arguments]]


ProcessPlot[info_] := BarChart @ execute[info]


End[] 

EndPackage[]