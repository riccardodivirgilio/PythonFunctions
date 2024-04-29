class MyAPIClass:

    def add_two(self, n):
        return n + 2

    def double(self, n):
        return n * 2


def api(method, *args, **opts):
    return getattr(MyAPIClass(), method)(*args, **opts)
