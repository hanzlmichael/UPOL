#include <iostream>
#include <string>
#include <algorithm>

using namespace std;

template<class K, class D, unsigned n>
class UMapa {
	struct Prvek {
		K klic; D data;
		bool operator < (const Prvek & other) {
			return klic < other.klic;
		}
		bool operator < (const K & other) {
			return klic < other.klic;
		}
	};

	Prvek * pole = new Prvek[n];
	unsigned pocet = 0;
	unsigned size = n;
public:
	void vlozit(const K & klic, const D & data) {
		if (size < 1) return;
		if (pocet == 0) {
			pole[pocet].klic = klic;
			pole[pocet++].data = data;
			return;
		}
		int nalezeno = binarySearch(pole, 0, pocet, klic);
		if (nalezeno == -1) {
			Prvek novyPrvek{ klic, data };
			if (pocet == size) {
				Prvek * novePole = new Prvek[size * 2];
				for (int i = 0; i < pocet; i++) {
					novePole[i].klic = pole[i].klic;
					novePole[i].data = pole[i].data;
				}
				delete[] pole;
				pole = novePole;
				size *= 2;
			}
			pocet++;
			for (int i = 0; i < pocet - 1; i++) {
				if (novyPrvek < pole[i]) {
					for (int j = pocet - 1; j > i; --j) {
						pole[j] = pole[j - 1];
					}
					pole[i] = novyPrvek;
					break;
				}
				if (i == pocet - 2) pole[pocet - 1] = novyPrvek;
			}
		}
		else {
			pole[nalezeno].data = data;
		}
	}

	bool odebrat(const K & k) {
		int nalezeno = binarySearch(pole, 0, pocet, k);
		if (nalezeno != -1) {
			--pocet;
			for (int i = nalezeno; i < pocet; i++) {
				pole[i].klic = pole[i + 1].klic;
				pole[i].data = pole[i + 1].data;
			}
			return true;
		}
		else {
			return false;
		}
	}

	const D * operator [] (const K & k) const {
		int nalezeno = binarySearch(pole, 0, pocet, k);
		if (nalezeno != -1) {
			return &pole[nalezeno].data;
		}
		return nullptr;
	}

	int binarySearch(Prvek arr[], int l, int r, K x) const {
		if (r >= l) {
			int mid = l + (r - l) / 2;
			if (!(arr[mid].klic < x || x < arr[mid].klic))
				return mid;
			if (arr[mid].klic < x)
				return binarySearch(arr, mid + 1, r, x);
			else
				return binarySearch(arr, l, mid - 1, x);
		}
		return -1;
	}

	Prvek * getPole() {
		return pole;
	}

	int getPocet() {
		return pocet;
	}
};


int main() {
	UMapa<int, string, 1> m;

	m.vlozit(3, "c");
	m.vlozit(3, "c");
	m.vlozit(7, "g");
	m.vlozit(3, "c");

	m.odebrat(3);

	auto a = m.getPole();

	for (int i = 0; i < m.getPocet(); i++) {
		cout << a[i].klic << " " << a[i].data << endl;
	}
	cout << endl;
}