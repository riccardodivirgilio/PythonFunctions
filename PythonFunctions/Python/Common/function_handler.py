from wolframclient.utils.importutils import import_string
from wolframclient.utils.importutils import (
    safe_import_string_and_call as import_string_and_call,
)


def function_handler(path, validate_call=True):
    func = import_string(path)

    assert callable(func), "{} must be callable".format(path)

    if validate_call:
        func = import_string_and_call(
            "pydantic.validate_call",
            func,
            validate_return=True,
            config={
                "arbitrary_types_allowed": True, 
                "strict": False, 
            },
        ) 

    return func
