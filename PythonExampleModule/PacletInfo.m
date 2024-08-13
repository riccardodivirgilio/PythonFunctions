Paclet[
	Name -> "PythonExampleFile",
	Version -> "0.0.1",
	MathematicaVersion -> "14.1+",
	Description -> "PythonExampleFile Library",
	Creator -> "Riccardo Di Virgilio <riccardod@wolfram.com>",
	Extensions -> {
		{"Kernel", 
            "Root" -> ".", 
			"Context" -> {"PythonFunctions`"}, 
			"Symbols" -> {}
		},
		{
			"PythonFunctions",
			"Namespace" -> "ModuleExample",
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
		}
	}
]
