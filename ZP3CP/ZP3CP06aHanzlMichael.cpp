#include <iostream>
#include <fstream> 
#include <string>
#include <algorithm> 
#include <iterator> 
#include <cstring>

using namespace std;

int find(int x, int p[], int count) {
	for (int i = 0; i < count; i++) {
		if (x == p[i]) {
			return i;
		}
	}
	return -1;
}

class Mnozina {
	int *p;
	int count = 0;
	int size;
public: 
	Mnozina(int n) { p = new int[n]; size = n; }
	~Mnozina() { delete[] p; }

	Mnozina(const Mnozina& other, int size) : size(other.size) {
		count = other.count;
		this->size = other.size;
		p = new int[size];
		size_t s = size * sizeof(int);
		memcpy(p, other.p, s);
	}

	Mnozina(const Mnozina& other) : size(other.size) {
		count = other.count;
		size = other.size;
		p = new int[size];
		size_t s = size * sizeof(int);
		memcpy(p, other.p, s);
	}

	friend void vypsat(Mnozina &);

	Mnozina & operator << (int n) {
		if (find(n, p, count) == -1) {
			if (count == size) {
				int *newSize = new int[2 * size];
				memcpy(newSize, p, sizeof(int) * count);
				p = newSize;
				size *= 2;
			}
			p[count] = n;
			count++;
		}
		return *this;
	}

	Mnozina & operator -= (int n) {
		int index = find(n, p, count);
		if (index != -1) {
			for (int i = index; i < count; i++) {
				p[i] = p[i+1];
			}
			count--;
		}
		return *this;
	}

	Mnozina & operator += (Mnozina &m) {
		for (int i = 0; i < m.count; i++) {
			*this << m.p[i];
		}
		return *this;
	}

	Mnozina & operator -= (Mnozina &m) {
		for (int i = 0; i < m.count; i++) {
			*this -= m.p[i];
		}
		return *this;
	}

	int operator + (void) {
		return count;
	}

	int operator * (void) {
		return size;
	}
};

void vypsat(Mnozina & m) {
	if (m.count == 0) {
		cout << "Prazdna mnozina" << endl;
		return;
	}
	int counter = 0;
	for (int i = 0; i < m.count; i++) {
		if (counter == 10) {
			cout << endl;
			counter = 0;
		}
		cout << m.p[i] << " ";
		counter++;
	}
	cout << endl; 
}


int main() {

	Mnozina M(5);
	Mnozina N(5);

	// pridani prvku z pole nums1 do mnoziny m

	int nums1[] = { 1,2,3,4,5,6 };

	for (int i = 0; i < 6; i++) {
		M << nums1[i];
	}

	// pridani prvku z pole nums2 do mnoziny n

	int nums2[] = { 1,2,8 };

	for (int i = 0; i < 3; i++) {
		N << nums2[i];
	}

	// vypsani obou mnozin 

	vypsat(M);
	vypsat(N);

	// odebrani prvku z mnoziny M a nasledne vypsani mnoziny m

	M -= 5;
	vypsat(M);

	// sjednoceni mnozin M a N, nasledne vypsani

	M += N;
	vypsat(M);
	vypsat(N);

	// rozdil mnozin M a N, a nasledne vypsani

	M -= N;
	vypsat(M);
	vypsat(N);
	// aktualni pocet cisel ulozenych v mnozine M

	cout << +M << endl;

	// aktualni velikost pole pro ulozeni cisel v mnozine M

	cout << *M << endl;
	cout << endl;
}