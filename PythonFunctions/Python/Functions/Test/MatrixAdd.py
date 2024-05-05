from typing import List


def MatrixAdd(Dates: List[List[int]], Delta: int = 1) -> List[List[int]]:
    return [[d + Delta for d in date_list] for date_list in Dates]
