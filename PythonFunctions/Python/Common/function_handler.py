
from wolframclient.utils.importutils import import_string, safe_import_string_and_call as import_string_and_call

def function_handler(path, validate_call = True):
    func = import_string(path)

    assert callable(func), "%s must be callable" % (path, )

    if validate_call:
        return import_string_and_call(
            'pydantic.validate_call', 
            func, 
            validate_return = True, 
            config = {'arbitrary_types_allowed': True}
        )

    return func