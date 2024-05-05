import datetime

import numpy as np

from typing import List
from typing_extensions import TypedDict

def MatrixAdd(
    Dates: List[List[int]], Delta: int = 1
) -> List[List[int]]:
    return [[d + Delta for d in date_list] for date_list in Dates]
