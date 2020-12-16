#include <iostream>
#include <string>
#include <algorithm>

using namespace std;

template<class D, class P, unsigned n>
class PF {
	struct Prvek {
		D data; P priority;
		bool operator < (const P & other) {
			return priority < other.priority;
		}
	};

	Prvek * pole = new Prvek[n];
	unsigned counter = 0;
	unsigned size = n;

public:

	void pridat(const D & data, const P & priority) {
		try {
			if (counter == size) throw "Pole je plne";
			pole[counter].data = data;
			pole[counter].priority = priority;
			counter++;
		}
		catch (const char *e) { cout << e << endl; }
	}

	bool odebrat() {
		try {
			if (counter == 0) throw "Pole je prazdne";
			int max = 0;

			for (int i = 1; i < counter; i++) {
				if (pole[max].priority < pole[i].priority) {
					max = i;
				}
			}

			counter--;
			for (int i = max; i < counter; i++) {
				pole[i].data = pole[i + 1].data;
				pole[i].priority = pole[i + 1].priority;
			}
			return true;
		}
		catch (const char *e) { cout << e << endl; return false; }
	}

	unsigned pocet() {
		return counter;
	}
};

int main() {

	PF <int, int, 5> p;
	p.pridat(7, 5);
	p.pridat(15, 6);
	p.pridat(5, 6);
	p.pridat(10, 6);
	p.pridat(9, 3);
	p.odebrat();
	p.odebrat();
	p.odebrat();
	cout << p.pocet();

}
