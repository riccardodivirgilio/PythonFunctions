import sample_module

def dispatch(name, *args, **opts):
    return getattr(sample_module, name)(*args, **opts)