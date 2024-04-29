class API:

    def add_two(self, n):
        return n + 2

    def double(self, n):
        return n * 2


def dispatch_method(method, *args, **opts):
    return getattr(API(), method)(*args, **opts)
