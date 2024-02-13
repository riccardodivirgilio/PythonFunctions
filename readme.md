# sample package to use python functions

```
TestAddTwo[ 23]
TestDouble[23]
TestDispatch["add_two", 23]
TestDispatch["double", 23]
```

The are environments defined under: Python/Environments

each environment defines a requirement.txt file and multiple entry points.

The entry point is a python file that returns any kind of python expression, typically a function.

The entrypoint is called using the following function that takes 3 arguments:

1. environment name
2. entry point name
3. a function to call the entrypoint

```
    executePythonEntrypoint[
        "Test", 
        "Dispatch", 
        Function[
            {session, func},
            {
                func["add_two", 3],
                func["double", 2]
            }
        ]
    ]
```

executePythonEntrypoint takes care of creating the python environment, start the session and close the session after the function call is done. 