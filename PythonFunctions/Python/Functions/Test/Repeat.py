import datetime

import numpy as np

from typing import List
from typing_extensions import TypedDict

def Repeat(Main: str, Count: int = 1, *, Separator: str = "") -> str:
    return Separator.join(Main for _ in range(Count))
