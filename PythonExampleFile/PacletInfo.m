Paclet[
	Name -> "PythonExampleFile",
	Version -> "0.0.1",
	MathematicaVersion -> "14.1+",
	Description -> "PythonExampleFile Library",
	Creator -> "Riccardo Di Virgilio <riccardod@wolfram.com>",
	Extensions -> {
		{
			"PythonFunctions",
			"Namespace" -> "Code",
			"Root" -> "Source/AnotherEnv"
		},
		{
			"PythonFunctions",
			"Namespace" -> "Science",
			"Root" -> "Source/Science",
			"Evaluator" -> <|
				"Dependencies" -> {"lightcurve", "pydantic"}
			|>
		},
		{
			"PythonFunctions",
			"Namespace" -> "Code",
			"Root" -> "Source/Code",
			"Evaluator" -> <|
				"Dependencies" -> {"lightcurve", "pydantic"}
			|>
		}
	}
]
