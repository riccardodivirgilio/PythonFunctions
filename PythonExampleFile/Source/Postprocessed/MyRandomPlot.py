
import random

def create_random_data(length : int = 10, minimum : int = 0, maximum : int = 100):
    for i in range(length):
        yield random.randint(minimum, maximum)