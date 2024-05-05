Paclet[
	Name -> "PythonFunctions",
	Version -> "0.0.1",
	MathematicaVersion -> "14+",
	Description -> "PythonFunctions Library",
	Creator -> "Riccardo Di Virgilio <riccardod@wolfram.com>",
	Loading -> Automatic,
	Extensions -> {
        {"Resource", 
        	"Root" -> ".", 
			"Resources" -> {
		    	{"Manifest", "Meta/Manifest.wxf"}
	    	}
        },
        {"Resource", 
        	"Root" -> "Python", 
        	"Resources" -> {"Common", "Functions"}
        },

		{"Kernel", 
            "Root" -> ".", 
			"Context" -> {"PythonFunctions`"}, 
			"Symbols" -> {}
		},
		{"Kernel", 
            "Root" -> ".", 
			"Context" -> {"PythonFunctionsBuilder`"}, 
			"Symbols" -> {}
		}
	}
]
