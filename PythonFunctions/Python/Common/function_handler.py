from wolframclient.utils.importutils import import_string
from wolframclient.utils.importutils import (
    safe_import_string_and_call as import_string_and_call,
)
from wolframclient.language import wl
from functools import partial

def run_validation(func, *args, **opts):

    from pydantic import ValidationError

    try:
        return func(*args, **opts)
    except ValidationError as exception:

        errors = exception.errors()

        for err in errors:
            #dropping pydantic urls
            err.pop('url')

        # Experimental automatic listability

        if len(errors) == 1 and errors[0]['loc'] == (0, ) and not errors[0]['type'] == 'list_type':

            if isinstance(args[0], (tuple, list)):
                return tuple(
                    run_validation(func, p, *args[1:], **opts)
                    for p in args[0]
                )
            if isinstance(args[0], dict):
                return {
                    k: run_validation(func, p, *args[1:], **opts)
                    for k, p in args[0].items()
                }

        return wl.Failure(
            "InterpretationFailure", {
                #'MessageTemplate': "\n".join(err['msg'] for err in errors),
                'MessageTemplate': str(exception),
                'MessageParameters': {},
                'Errors': errors
            }
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

        func = partial(run_validation, func)

    return func
