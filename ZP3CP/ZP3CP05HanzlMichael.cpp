#define _USE_MATH_DEFINES
#include <cmath>
#include <iostream>
#include <fstream>
#include <string>
#include <vector> 
#include <iomanip>
#include <typeinfo>

using namespace std;

class Teleso {
protected:
	float vyska;
public:
	Teleso(float v) : vyska(v) { }
	virtual float objem() = 0;
};

class Kvadr : public Teleso {
private:
	float stranaA;
	float stranaB;
public:
	Kvadr(float s1, float s2, float v) : stranaA(s1), stranaB(s2), Teleso(v) { }
	float objem() {
		return stranaA * stranaB * vyska;
	}
};

class TelesoSKruhovouPodstavou : public Teleso {
protected:
	float polomer;
public:
	TelesoSKruhovouPodstavou(float p, float v) : polomer(p), Teleso(v) { }
	float obsah() { return M_PI * (pow(polomer, 2)); }
};

class Valec : public TelesoSKruhovouPodstavou {
public:
	Valec(float p, float v) : TelesoSKruhovouPodstavou(p, v) { }
	float objem() {
		return obsah() * vyska;
	}
};

class Kuzel : public TelesoSKruhovouPodstavou {
public:
	Kuzel(float p, float v) : TelesoSKruhovouPodstavou(p, v) { }
	float objem() {
		return (1 / 3.0) * obsah() * vyska;
	}
};

int main() {
	Teleso *t[3] = { new Kvadr(1,2,3), new Valec(1, 2), new Kuzel(1,2) };
	for (auto i : t) {
		cout << typeid(*i).name() << " " << i->objem() << endl;
	}
}
 
