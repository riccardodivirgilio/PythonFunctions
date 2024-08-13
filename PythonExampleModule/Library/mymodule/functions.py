
from mymodule.utils import reverse_string

from faker import Faker
import random

def create_name(lang : str = 'en_EN'):
	return Faker(lang).name()

def reversed_name(lang : str = 'en_EN'):
	return reverse_string(create_name(lang))

def create_random_data(length : int = 10, minimum : int = 0, maximum : int = 100):
	for i in range(length):
		yield random.randint(minimum, maximum)