import datetime

import numpy as np

from typing import List
from typing_extensions import TypedDict

def DatesAdd(
    Dates: List[datetime.datetime], Delta: datetime.timedelta = 1
) -> List[datetime.datetime]:
    return [d + Delta for d in Dates]
