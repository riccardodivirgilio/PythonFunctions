
from mymodule.utils import reverse_string

from faker import Faker
import random

def create_name():
	fake = Faker('it_IT')
	return fake.name()

def reversed_name():
	return reverse_string(create_name())

def create_random_data(length : int = 10, minimum : int = 0, maximum : int = 100):
	for i in range(length):
		yield random.randint(minimum, maximum)