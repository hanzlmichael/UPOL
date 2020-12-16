#pragma warning(suppress : 4996)
#include <windows.h>
#include <assert.h>
#include <fstream>
#include <string>
#include <iostream>
#include <vector> 
#include <iomanip>
#include <string>
using namespace std;

class Seznam {
	static Seznam *prvni, *posledni, *iterator;
	char *retez;
	Seznam *predchozi, *dalsi;
public:
	static bool direction; // sdilena promenna pro nastaveni smeru prochazeni seznamu 
	// konstruktor
	Seznam(const char * ret, bool konec = false) {
		// prideleni pameti pro retezec
		int len = strlen(ret) + 1;
		retez = new char[len];
		strcpy_s(retez, len, ret);

		if (prvni == nullptr) {
			posledni = prvni = this;
			this->predchozi = nullptr;
			this->dalsi = nullptr;
			return;
		}
		// pridavam na konec seznamu
		if (konec == true) {
			posledni->dalsi = this;
			this->predchozi = posledni;
			posledni = this;
		}
		// pridavam na zacatek seznamu
		if (konec == false) {
			prvni->predchozi = this;
			this->dalsi = prvni;
			prvni = this;
		}
	}

	const char *data() const {
		return retez;
	}

	static bool nastavitNaPrvni() {
		direction = true; // nastaveni smeru posunovani
		if (prvni != nullptr) {
			iterator = prvni;
			return true;
		}
		else {
			iterator = nullptr;
			return false;
		}
	}

	static bool nastavitNaPosledni() {
		direction = false; // nastaveni smeru posunovani 
		if (prvni != nullptr) {
			iterator = posledni;
			return true;
		}
		else {
			iterator = nullptr;
			return false;
		}
	}

	static Seznam *aktualni() {
		return iterator;
	}

	static bool posunoutNaDalsi() {
		if (direction) {
			if (iterator->dalsi) {
				iterator = iterator->dalsi;
				return true;
			}
			else {
				iterator = nullptr;
				return false;
			}
		}
		else {
			if (iterator->predchozi) {
				iterator = iterator->predchozi;
				return true;
			}
			else {
				iterator = nullptr;
				return false;
			}
		}
	}
};

Seznam *Seznam::prvni = nullptr;
Seznam *Seznam::posledni = nullptr;
Seznam *Seznam::iterator = nullptr;
bool Seznam::direction = true;

int main() {
	typedef Seznam S;
	new S("Marek");
	new S("Jana");
	new S("Michal");
	new S("Eva", true);
	new S("Hana", true);
	new S("Monika");
	new S("Lucie");
	new S("Radek", true);
	new S("Jitka", true);
	new S("Jakub");
	new S("Veronika", true);
	new S("Irena");

	Seznam::nastavitNaPrvni();

	do {
		cout << Seznam::aktualni()->data() << endl;
	} while (Seznam::posunoutNaDalsi());

	cout << endl;

	Seznam::nastavitNaPosledni();

	do {
		cout << Seznam::aktualni()->data() << endl;
	} while (Seznam::posunoutNaDalsi());

	cout << endl;

	system("PAUSE");

}