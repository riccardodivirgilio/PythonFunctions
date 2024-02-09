Package["Hacks`"]

SetAttributes[OSXEcho, SequenceHold]
OSXEcho[x_] := (RunProcess[{"osascript", "-e", 
   "display notification " <> 
    ToString[ToString[Unevaluated[x], InputForm], InputForm] <> 
    " with title \"Mathematica\""}]; Unevaluated[x])

RunTerminal[cmd_] := RunProcess[{"osascript", "-e", "	tell application \"Terminal\"
 	  activate
 	  do script \"" <> cmd <> "\"
 	end tell"}]["StandardOutput"]


Screenshot[HoldPattern[url:_URL|_CloudObject], rest___] := 
	Screenshot[First[url], rest]

Screenshot[url_String, s_: Automatic] := With[{
	name = FileNameJoin[{$TemporaryDirectory,  CreateUUID["screenshot-web2png-"] <> ".png"}],
	size = Replace[
		s, {
			Automatic|None :> {"1024px"}, 
			{h_, w_} :> {ToString[h], ToString[w]}, 
			h_ :> {"1024px", ToString[h]}
		}
	]},
	Key["StandardOutput"] @ RunProcess[{
		"/usr/local/bin/phantomjs", 
		FileNameJoin[{PacletManager`PacletResource["Hacks", "JS"], "rasterize.js"}],
		url, 
		name,
		StringJoin @ Riffle[size, "*"]
	}];
	Hyperlink[
		Import[name, "PNG"], 
		If[
			StringStartsQ[
				url, 
				"/"
			],
			"file://" <> url,
			url
		]
	]
]

Screenshot[res_HTTPResponse, rest___] := 
    With[
        {file = FileNameJoin[{
            $TemporaryDirectory, 
            StringJoin[
                "HTTPResponse-",
                IntegerString[Hash @ res, 36, 13],
                ".html"
            ]}]},
        BinaryWrite[file, res["BodyBytes"]];
        Close[file];
        Screenshot[file, rest]
    ]

Screenshot[any_, rest___] := 
	Screenshot[GenerateHTTPResponse[any], rest]