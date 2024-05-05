import datetime

import numpy as np

from typing import List
from typing_extensions import TypedDict


def ArrayReshape(Array: np.ndarray, Dimension1: int, Dimension2: int) -> np.ndarray:
    return Array.reshape(Dimension1, Dimension2)
