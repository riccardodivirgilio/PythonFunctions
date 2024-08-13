
### PythonExampleFile

This module provides boilerplate to wrap python functions using only files.

## Examples

The following repeats a string multiple times

```
PythonFunction["Repeat"]["ciao", 3]
```

The function input is validated using pydantic, try to use invalid argument types

```
PythonFunction["Repeat"][3]
```

Under Postprocessed there is a function postprocessed using a WL file

```
PythonFunction["MyRandomPlot"][12]
```