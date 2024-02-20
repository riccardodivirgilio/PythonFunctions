import inspect

PARAMETER_MAPPING = {
    getattr(inspect.Parameter, attr): attr
    for attr in (
        'POSITIONAL_ONLY',      
        'POSITIONAL_OR_KEYWORD',
        'VAR_POSITIONAL',       
        'KEYWORD_ONLY',         
        'VAR_KEYWORD',  
    )        
}

def serialize_parameters(func, sig):
    for n, p in sig.parameters.items():
        kind = PARAMETER_MAPPING[p.kind]

        if kind in ('VAR_POSITIONAL', 'VAR_KEYWORD'):
            raise NotImplementedError('parameter named %s of type %s is not supported' % (n, kind))

        yield n, {'Kind': kind}

def inspect_function(func):
    sig = inspect.signature(func)

    return {'Parameters': dict(serialize_parameters(func, sig))}