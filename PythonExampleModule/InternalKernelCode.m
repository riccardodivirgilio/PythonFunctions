
BeginPackage["InternalKernelCode`"]

Begin["`Private`"]

RunExternalEvaluate = Function[ExternalEvaluate[#Session, #Command -> #Arguments]]


MyBarChart[data_] := BarChart[data, ChartStyle -> "DarkRainbow"]


End[] 

EndPackage[]