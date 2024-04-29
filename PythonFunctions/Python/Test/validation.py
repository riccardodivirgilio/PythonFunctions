import numpy as np
import datetime



def repeat(Main: str, Count: int = 1, *, Separator: str = '') -> str:
    return Separator.join(Main for _ in range(Count))

def array_reshape(Array: np.ndarray, Dimension1: int, Dimension2: int) -> np.ndarray:
    return Array.reshape(Dimension1, Dimension2)

from typing import List


def dates_add(Dates: List[datetime.datetime], Delta: datetime.timedelta = 1) -> List[datetime.datetime]:
    return tuple(d + Delta for d in Dates)


from typing_extensions import TypedDict


class Movie(TypedDict):
    Name: str
    Year: int

class Information(TypedDict):
    Rating: int

# This function expects two keyword arguments - `name` of type `str`
# and `year` of type `int`.
def movie_rating(movie: Movie) -> Information:
    return Information(Rating = movie['Year'] % 10)