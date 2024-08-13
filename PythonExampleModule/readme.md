
### PythonExampleModule

This module provides boilerplate to wrap python functions using a custom Python module and a custom Wolfram Kernel extension.

## Python only examples

Create a datetime using the datetime module

```
PythonFunction["DateTime"][2012, 10, 10]
```

## Python and WL examples

Create a random name, using faker library:

```
PythonFunction["Name"]["it_IT"]
```

The input is validated using pydantic, try to run the following to see automatic error handling

```
PythonFunction["Name"][1]
```

ReversedName is similar but returns the reversed string.

```
PythonFunction["ReversedName"][]
```

Create a random barchart, generates data in python and processes the result by using Barchart

```
PythonFunction["RandomPlot"][10]
```

Create a random barchart, generates data in python and processes the result by using a custom barchart wrapper

```
PythonFunction["RandomStyledPlot"][10]
```
