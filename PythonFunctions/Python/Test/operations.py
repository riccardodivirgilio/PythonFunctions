import operator


def operate_on_numbers(n1, n2, /, Operation = 'add'):
    return getattr(operator, Operation)(n1, n2)