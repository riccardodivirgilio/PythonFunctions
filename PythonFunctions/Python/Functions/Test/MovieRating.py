import datetime

import numpy as np

from typing import List
from typing_extensions import TypedDict

class Movie(TypedDict):
    Name: str
    Year: int


class Information(TypedDict):
    Rating: int
    Voters: int

def MovieRating(movie: Movie) -> Information:
    return Information(Rating=movie["Year"] % 10, Voters=movie["Year"] * 2000)
