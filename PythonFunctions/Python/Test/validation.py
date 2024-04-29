import datetime

import numpy as np

from typing import List
from typing_extensions import TypedDict

def Repeat(Main: str, Count: int = 1, *, Separator: str = "") -> str:
    return Separator.join(Main for _ in range(Count))

def ArrayReshape(Array: np.ndarray, Dimension1: int, Dimension2: int) -> np.ndarray:
    return Array.reshape(Dimension1, Dimension2)

def DatesAdd(
    Dates: List[datetime.datetime], Delta: datetime.timedelta = 1
) -> List[datetime.datetime]:
    return [d + Delta for d in Dates]


class Movie(TypedDict):
    Name: str
    Year: int


class Information(TypedDict):
    Rating: int
    Voters: int

def MovieRating(movie: Movie) -> Information:
    return Information(Rating=movie["Year"] % 10, Voters=movie["Year"] * 2000)
