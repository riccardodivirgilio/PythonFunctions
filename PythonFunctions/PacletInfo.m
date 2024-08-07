Paclet[
	Name -> "PythonFunctions",
	Version -> "0.0.1",
	MathematicaVersion -> "14.1+",
	Description -> "PythonFunctions Library",
	Creator -> "Riccardo Di Virgilio <riccardod@wolfram.com>",
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
			"Namespace" -> "Code",
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
			"Namespace" -> "Code",
			"Root" -> "Python/Functions/Code",
			"Evaluator" -> <|
				"Dependencies" -> {"lightcurve", "pydantic"}
			|>
		}
	}
]
