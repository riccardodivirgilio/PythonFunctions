Paclet[
	Name -> "PythonFunctions",
	Version -> "0.0.1",
	MathematicaVersion -> "14+",
	Description -> "PythonFunctions Library",
	Creator -> "Riccardo Di Virgilio <riccardod@wolfram.com>",
	Loading -> Automatic,
	Extensions -> {
        {"Resource", 
        	"Root" -> "Python", 
        	"Resources" -> {"Common", "Functions"}
        },
		{"Kernel", 
            "Root" -> ".", 
			"Context" -> {"PythonFunctions`"}, 
			"Symbols" -> {}
		},
		{
			"PythonFunctions",
			"Namespace" -> "AnotherEnv",
			"Root" -> "Python/Functions/AnotherEnv"
		},
		{
			"PythonFunctions",
			"Namespace" -> "Science",
			"Root" -> "Python/Functions/Science",
			"Evaluator" -> <|
				"Dependencies" -> {"lightcurve", "pydantic"}
			|>
		},
		{
			"PythonFunctions",
			"Namespace" -> "Test",
			"Root" -> "Python/Functions/Test",
			"Evaluator" -> <|
				"Dependencies" -> {"lightcurve", "pydantic"}
			|>
		}
	}
]
