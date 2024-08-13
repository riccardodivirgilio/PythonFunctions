class MyAPIClass:

    def add_two(self, n):
        return n + 2

    def double(self, n):
        return n * 2


def Dispatch(method, *args, **opts):
    return getattr(MyAPIClass(), method)(*args, **opts)
