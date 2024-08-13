Needs["PythonFunctions`"]

TestCreate[
    PythonFunction["MyRandomPlot"][12],
    _Graphics,
    TestID -> "PythonFunction-RandomPlot-File",
    SameTest -> MatchQ
]

TestCreate[
    PythonFunction["RandomPlot"][12],
    _Graphics,
    TestID -> "PythonFunction-RandomPlot-Module",
    SameTest -> MatchQ
]

TestCreate[
    PythonFunction["DateTime"][2012, 10, 10],
    DateObject[__],
    TestID -> "PythonFunction-DateTime",
    SameTest -> MatchQ
]

TestCreate[
    PythonFunction[{"Dates", "DateTime"}][2012, 10, 10],
    DateObject[__],
    TestID -> "PythonFunction-DateTime-NameSpace",
    SameTest -> MatchQ
]

TestCreate[
    PythonFunction[{"AnotherNamespace", "DateTime"}][2012, 10, 10],
    _Failure?FailureQ,
    TestID -> "PythonFunction-DateTime-NameSpace-Invalid",
    SameTest -> MatchQ
]

TestCreate[
    PythonFunction["Repeat"]["abc", 2],
    "abcabc",
    TestID -> "PythonFunction-Repeat-Valid"
]

TestCreate[
    PythonFunction["Repeat"][12],
    _Failure?FailureQ,
    TestID -> "PythonFunction-Repeat-Invalid",
    SameTest -> MatchQ
]
