Paclet[
	Name -> "PythonExampleFile",
	Version -> "0.0.1",
	MathematicaVersion -> "14.1+",
	Description -> "PythonExampleFile Library",
	Creator -> "Riccardo Di Virgilio <riccardod@wolfram.com>",
	Extensions -> {
		{
			"PythonFunctions",
			"Namespace" -> "Dates",
			"Functions" -> {
				"Datetime"   -> {"datetime", "datetime"},
				"Date"       -> {"datetime", "date"},
				"Now"        -> {"datetime", "datetime", "now"},
				"Today"      -> {"datetime", "date", "today"}
			},
			"Evaluator" -> <|
				"Dependencies" -> {}
			|>,
			"Validate" -> False
		},
		{
			"PythonFunctions",
			"Namespace" -> "ProcessedModule",
			"ImportPaths" -> {"Library"},
			"Functions" -> {
				"Name"           -> {"mymodule.functions", "create_name"},
				"ReversedName"   -> {"mymodule.functions", "reversed_name"},
				"RandomPlot"     -> {"mymodule.functions", "create_random_data"}
			},
			"Handlers" -> {
				"RandomPlot" -> "InternalKernelCode`ProcessPlot"
			},
			"Evaluator" -> <|
				"Dependencies" -> {"faker", "pydantic"}
			|>,
			"Validate" -> True,
			"Needs" -> {"InternalKernelCode`"}
		},
		{"Kernel", 
            "Root" -> ".", 
			"Context" -> {"InternalKernelCode`"}, 
			"Symbols" -> {}
		}
	}
]
