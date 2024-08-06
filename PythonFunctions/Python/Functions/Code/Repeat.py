def Repeat(Main: str, Count: int = 1, *, Separator: str = "") -> str:
    return Separator.join(Main for _ in range(Count))
