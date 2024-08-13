Paclet[
	Name -> "PythonExampleModule",
	Version -> "0.0.1",
	MathematicaVersion -> "14.1+",
	Description -> "PythonExampleModule Library",
	Creator -> "Riccardo Di Virgilio <riccardod@wolfram.com>",
	Extensions -> {
		{
			"PythonFunctions",
			"Namespace" -> "Science",
			"Root" -> "Source/Science",
			"Evaluator" -> <|
				"Dependencies" -> {"lightcurve", "pydantic"}
			|>,
			"Validate" -> True
		},
		{
			"PythonFunctions",
			"Namespace" -> "Code",
			"Root" -> "Source/Code",
			"Evaluator" -> <|
				"Dependencies" -> {"lightcurve", "pydantic"}
			|>,
			"Validate" -> True
		},
		{
			"PythonFunctions",
			"Namespace" -> "Postprocessed",
			"Root" -> "Source/Postprocessed",
			"Evaluator" -> <|
				"Dependencies" -> {"pydantic"}
			|>,
			"Validate" -> True
		}
	}
]
