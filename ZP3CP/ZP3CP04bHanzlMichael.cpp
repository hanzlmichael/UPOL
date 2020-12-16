#include <windows.h>
#include <assert.h>
#include <fstream>
#include <string>
#include <iostream>
#include <vector> 
#include <iomanip>
#include <algorithm>
using namespace std;

class UsporadanePole
{
	int* pole; 
	const int n; 
	int pocet = 0; 
public:
	friend void vypsat(const UsporadanePole &);

	UsporadanePole(int n) : n(n)
	{
		pole = new int[n] {};
	}

	~UsporadanePole() {
		delete [] pole;  
	}

	UsporadanePole(const UsporadanePole& other, int n) : n(other.n) {
		pole = new int[n];
		size_t size = n * sizeof(int);
		memcpy(pole, other.pole, size);
	}

	UsporadanePole(const UsporadanePole& other) : n(other.n) {
		pole = new int[n];
		size_t size = n * sizeof(int);
		memcpy(pole, other.pole, size);
	}

	int najit(int e) const {

		int l = 0;
		int r = pocet - 1;
		int x = e;

		while (l <= r)
		{
			int m = l + (r - l) / 2;
			if (pole[m] == x)
				return m;
			if (pole[m] < x)
				l = m + 1;
			else
				r = m - 1;
		}
		return -1;
	}

	int pridat(int e) {
		if (pocet == n) {
			return -1;
		}

		for (int i = 0; i < pocet; i++) {
			if (pole[i] == e) {
				return 0;
			}
		}

		for (int i = 0; i < pocet; i++) {
			if (e < pole[i]) {
				for (int j = pocet + 1; j > i; j--) {
					pole[j] = pole[j - 1];
				}
				pole[i] = e;
				pocet++;
				return 1;
			}
		}
		pole[pocet] = e;
		pocet++;
		return 1;
	}

	bool odebrat(int e) {
		int isInArray = najit(e);

		if (isInArray == -1) return false;

		for (int i = isInArray + 1; i < pocet; i++) {
			pole[i - 1] = pole[i];
		}
		pocet--;
		return true;
	}

	int prvek(int e) const {
		int index = najit(e);
		if (index == -1) {
			return INT_MIN;
		}
		else {
			return pole[index];
		}
	}		
};

void vypsat(const UsporadanePole & UP) {
	int count = 0;

	for (int i = 0; i < UP.pocet; i++) {
		if (count == 5) { cout << endl; count = 0; }
		cout << UP.pole[i] << " ";
		count++;
	}
}

int main() {
	UsporadanePole u(10);
	int arr[] = { 1,3,5,7,5, 2,4,6,2,0 ,6,9,8,-2,-5 };

	for (int i = 0; i < 15; i++) {
		u.pridat(arr[i]);
	}

	vypsat(u);

	cout << "\n\n";

	int arr2[] = { 2,-5,4,7,-6 };

	for (int i = 0; i < 5; i++) {
		int j = u.prvek(arr2[i]);
		if (j == INT_MIN) cout << "Cislo " << arr2[i] << " v poli neni\n";
		else cout << "Cislo " << arr2[i] << " v poli je\n";
	}

	int arr3[] = { 5,2,-7,5 };

	for (int i = 0; i < 4; i++) {
		u.odebrat(arr3[i]);
	}

	cout << endl;
	vypsat(u);
	cout << endl;
}