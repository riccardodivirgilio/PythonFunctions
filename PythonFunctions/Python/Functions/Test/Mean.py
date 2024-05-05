import datetime

import numpy as np

from typing import List
from typing_extensions import TypedDict
def Mean(Input: List[float]) -> float:
    return sum(Input) / len(Input)
