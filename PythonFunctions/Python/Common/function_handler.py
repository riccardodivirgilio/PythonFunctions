from functools import partial

from wolframclient.language import wl
from wolframclient.utils.importutils import import_string


def run_validation(func, *args, **opts):

    import pydantic

    try:
        return func(*args, **opts)
    except pydantic.ValidationError as exception:

        errors = exception.errors()

        if len(errors) == 1 and errors[0]["loc"] == (0,):

            if errors[0]["type"] == "list_type":

                if isinstance(args[0], dict):

                    return run_validation(func, args[0].values(), *args[1:], **opts)

                if not isinstance(args[0], (list, tuple)):

                    return run_validation(func, (args[0],), *args[1:], **opts)

            else:

                if isinstance(args[0], (tuple, list)):
                    return tuple(run_validation(func, p, *args[1:], **opts) for p in args[0])

                if isinstance(args[0], dict):
                    return {
                        k: run_validation(func, p, *args[1:], **opts)
                        for k, p in args[0].items()
                    }

                raise NotImplementedError("Should never happen 😅")

                # anything else is a valid error
        #

        return wl.Failure(
            "InterpretationFailure",
            {
                #'MessageTemplate': "\n".join(err['msg'] for err in errors),
                "MessageTemplate": str(exception),
                "MessageParameters": {},
                "Errors": tuple(
                    {
                        "Type": err["type"],
                        "Message": err["msg"],
                        "Path": tuple(i + 1 if isinstance(i, int) else i for i in err["loc"]),
                    }
                    for err in errors
                ),
            },
        )


def function_handler(path, validate_call=True):

    func = import_string(path)

    if validate_call:

        assert callable(func), "{} must be callable".format(path)

        import pydantic

        func = pydantic.validate_call(
            func,
            validate_return=True,
            config={
                "arbitrary_types_allowed": True, 
                "strict": False, 
            },
        )

        func = partial(run_validation, func)

    return func
