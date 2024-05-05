import datetime
from typing import List


def DatesAdd(
    Dates: List[datetime.datetime], Delta: datetime.timedelta = datetime.timedelta(seconds=1)
) -> List[datetime.datetime]:
    return [d + Delta for d in Dates]
