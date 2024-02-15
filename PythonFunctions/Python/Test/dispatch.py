class API:

    def add_two(self, n):
        return n + 2

    def double(self, n):
        return n * 2


api = API()

def dispatch(name, *args, **opts):
    return getattr(api, name)(*args, **opts)
