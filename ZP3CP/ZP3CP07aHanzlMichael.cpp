#include <iostream>
#include <string>
#include <algorithm>

using namespace std;

class Zlomek {
	unsigned c, j;
	void nsd() {
		auto a = c, b = j;
		for (;;) {
			auto r = a % b;
			if (r == 0) {
				c /= b, j /= b;
				return;
			}
			a = b;
			b = r;
		}
	}
public:
	Zlomek() {}
	Zlomek(unsigned c, unsigned j) :c(c), j(j) { nsd(); }

	friend bool operator < (Zlomek &, Zlomek &);

	Zlomek & operator *(const Zlomek &z)const {
		return Zlomek(c*z.c, j*z.j);
	}

	Zlomek & operator + (Zlomek & other) {		
		return Zlomek((c * other.j + other.c * j), j * other.j);
	}

	Zlomek & operator / (const unsigned div) {
		return Zlomek(c, div * j);
	}

	unsigned cit() const {
		return c;
	}
	unsigned jm() const { 
		return j;
	}
	void operator()(const char*s = "\n") const { cout << c << '/' << j << s; }	
};

bool operator < (Zlomek& z1, Zlomek& z2) {
	return z1.c * z2.j < z2.c * z1.j;
}

ostream & operator << (ostream &os, const Zlomek &z) {
	z();
	return os;
}

template <class T>
T median(T items[], size_t size) {
	T res;
	T * factory = new T[size];
	for (size_t i = 0; i < size; i++) {
		factory[i] = items[i];
	}
	sort(factory, factory + size);

	if (size % 2 == 0) {
		res = (factory[size / 2 - 1] + factory[size / 2]) / 2u;
	}
	else {
		res = factory[size / 2];
	}
	delete[] factory;
	return res;
}

int main() {

	Zlomek items[] = { Zlomek(5,3), Zlomek(2,7), Zlomek(4,3), Zlomek(1,2), Zlomek(9,4), Zlomek(2,5), Zlomek(3,8), Zlomek(2,3), Zlomek(3,2), Zlomek(4,5) };

	size_t size = sizeof(items) / sizeof(items[0]);

	cout << median(items, size);
	
}
