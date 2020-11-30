#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif
#include <iostream>
#include <fstream> 
#include <string>
#include <algorithm> 
#include <iterator> 
#include <cstring>
#include <vector>
#include <limits.h> 
#include <cfloat> 
#include <iomanip>

using namespace std;

float float_min = FLT_MIN;

char * prevod(const char *);

struct Zbozi {
	char *nazev;
	float cena;
};

ostream& operator << (ostream& os, const Zbozi& z) {
	os << left << setw(9) << z.nazev << " " << z.cena << "    ";
	return os;
}

bool operator < (const Zbozi& a, const Zbozi& b) {
	int res = strcmp(prevod(a.nazev), prevod(b.nazev));
	if (res == 1) {
		return false;
	}
	else {
		return true;
	}
}

class Cenik {
public:
	Zbozi * zbozi;
	unsigned int pocet = 0;
	unsigned int velikost;

	Cenik(int n) {
		zbozi = new Zbozi[n * sizeof(Zbozi)];
		velikost = n;
	}

	~Cenik() {
		delete[] zbozi;
	}

	Cenik (const Cenik& other) {
		pocet = other.pocet;
		velikost = other.velikost;
		zbozi = new Zbozi[velikost * sizeof(Zbozi)];
		for (int i = 0; i < pocet; i++) {
			char * jm = new char[strlen(other.zbozi[i].nazev) + 1];
			strcpy(jm, other.zbozi[i].nazev);
			zbozi[i].cena = other.zbozi[i].cena;
			zbozi[i].nazev = jm;
		}
	}

	void operator () (const char * jm, float cena) {

		int nalezeno;

		for (auto i = 0; i < pocet; i++) {
			nalezeno = strcmp(prevod(jm), zbozi[i].nazev);
			if (nalezeno == 0) {
				zbozi[i].cena = cena;
				return;
			}
		}

		if (pocet == velikost) {
			Zbozi * novePole = new Zbozi[2 * velikost * sizeof(Zbozi)];
			for (auto i = 0; i < pocet; i++) {
				novePole[i].cena = zbozi[i].cena;
				char * buffer = new char[strlen(jm) + 1];
				strcpy(buffer, zbozi[i].nazev);
				novePole[i].nazev = buffer;
			}
			velikost *= 2;
			delete[] zbozi;
			zbozi = novePole;
		}

		Zbozi * zb = new Zbozi[1 * sizeof(Zbozi)];
		zb->cena = cena;
		char * buff = new char[strlen(jm) + 1];
		strcpy(buff, prevod(jm));
		zb->nazev = buff;
		zbozi[pocet] = *zb;
		pocet++;
	}

	bool operator () (const char * jm) {
		int res;
		for (int i = 0; i < pocet; i++) {
			res = strcmp(prevod(zbozi[i].nazev), prevod(jm));
			if (res == 0) {
				delete zbozi[i].nazev;
				for (int j = i; j < pocet; j++) {
					zbozi[j] = zbozi[j + 1];
				}
				pocet--;
				return true;
			}
		}
		return false;
	}

	float & operator [] (const char * zb) {
		int nalezeno;
		for (int i = 0; i < pocet; i++) {
			nalezeno = strcmp(prevod(zb), zbozi[i].nazev);
			if (nalezeno == 0) {
				return zbozi[i].cena;
			}
		}
		return float_min;
	}

	unsigned operator + (void) {
		return pocet;
	}

	unsigned int operator * (void) {
		return velikost;
	}

	friend void vypsat(Cenik &);

};

void vypsat(Cenik & c) {
	int counter = 0;

	if (c.pocet == 0) {
		cout << "Prazdny cenik" << endl;
		return;
	}

	vector<Zbozi> z;
	for (int i = 0; i < c.pocet; i++) {
		z.push_back(c.zbozi[i]);
	}

	sort(z.begin(), z.end());

	for (auto i = z.begin(); i != z.end(); ++i) {
		if (counter == 5) { cout << endl; counter = 0; }
		cout << *i;
		counter++;
	}
	cout << endl;
}

int main()
{
	// vytvoreni ceniku kapacity '2'
	Cenik m(2);
	// vypis prazdneho ceniku
	vypsat(m);
	// pridam zbozi
	cout << "\nPridavam zbozi...\n";
	m("SalAm", 15.f);
	m("SALAM"); // salam se z ceniku vymaze
	m("sYr", 15.f);
	m("SYR", 20.90000f); // cena syru se zmeni
	m("kokos", 29.f);
	m("citrony", 13.f);
	m("pomerance", 29.00f);
	m("brambory", 19.f);
	m("MlEko", 14.f);
	m("Jogurt", 7.90f);
	vypsat(m);

	// pocet zbozi ulozeneho v ceniku
	cout << "\nPocet zbozi ulozeneho v ceniku: "<< +m << endl;

	// velikost pole pro ulozeni zbozi
	cout << "Velikost pole pro ulozeni zbozi: " << *m << endl;
	cout << endl;

	// pretizeni operatoru []
	cout << "Cena jogurtu: " << m["mleko"] << endl;
}

char * prevod(const char * ret) {
	char * str = new char[strlen(ret) + 1];

	for (int i = 0; ret[i] != '\0'; i++) {
		str[i] = tolower(ret[i]);
	}
	str[strlen(ret)] = '\0';
	return str;
}