#include <iostream>
#include <string>
#include <algorithm>

using namespace std;

template <class D, class P, unsigned n>
class PF
{
	struct Prvek
	{
		D data;
		P priority;
		bool operator<(const P &other)
		{
			return priority < other.priority;
		}
	};

	Prvek *pole = new Prvek[n];
	unsigned counter = 0;
	unsigned size = n;

public:
	void pridat(const D &data, const P &priority)
	{
		if (counter == size)
			throw "Pole je plne";
		pole[counter].data = data;
		pole[counter].priority = priority;
		counter++;
	}

	void odebrat()
	{
		if (counter == 0)
			throw "Pole je prazdne";
		int max = 0;

		for (int i = 1; i < counter; i++)
		{
			if (pole[max].priority < pole[i].priority)
			{
				max = i;
			}
		}

		counter--;
		for (int i = max; i < counter; i++)
		{
			pole[i].data = pole[i + 1].data;
			pole[i].priority = pole[i + 1].priority;
		}
	}

	unsigned pocet()
	{
		return counter;
	}
};

int main() {
}
