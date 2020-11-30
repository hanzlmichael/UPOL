#include <iostream>
#include <string>
using namespace std;

typedef const char* cstr;

unsigned int gray_encode(unsigned int b) {
	return b ^ (b >> 1);
}

unsigned int gray_decode(unsigned int g) {
	unsigned int b;
	b = 0;
	while (g) {
		b ^= g;
		g >>= 1;
	}
	return b;
}

string findDigitsInBinary(unsigned x) {
	string r;
	if (x == 0) return "0";
	else if (x == 1) return "1";
	else {
		while (x != 0) { r = (x % 2 == 0 ? "0" : "1") + r; x /= 2; }
	}
	return r;
}

class GK {
private:

	unsigned gkValue;
	unsigned binaryValue;

public:

	GK() {
		gkValue = 0u;
		binaryValue = 0u;
	}

	GK(unsigned x) {
		gkValue = gray_encode(x);
		binaryValue = x;
	}

	GK(cstr x) {
		gkValue = stoul(x, nullptr, 2);
		binaryValue = gray_decode(gkValue);
	}

	void setGkValue(unsigned x) {
		gkValue = x;
	}

	unsigned getGkValue() {
		return gkValue;
	}

	void setBinaryValue(unsigned x) {
		binaryValue = x;
	}

	unsigned getBinaryValue() {
		return binaryValue;
	}

	GK & operator + (unsigned other) {
		GK *obj = new GK();
		obj->binaryValue = this->binaryValue + other;
		obj->gkValue = gray_encode(obj->binaryValue);
		return *obj;
	}

	GK & operator + (cstr other) {
		GK *obj = new GK();
		obj->binaryValue = this->binaryValue + gray_decode(stoul(other, nullptr, 2));
		obj->gkValue = gray_encode(obj->binaryValue);
		return *obj;
	}

	GK & operator + (GK & other) {
		GK *obj = new GK();
		obj->binaryValue = this->binaryValue + other.binaryValue;
		obj->gkValue = gray_encode(obj->binaryValue);
		return *obj;
	}

	GK & operator - (unsigned other) {
		GK *obj = new GK();
		obj->binaryValue = this->binaryValue - other;
		obj->gkValue = gray_encode(obj->binaryValue);
		return *obj;
	}

	GK & operator - (cstr other) {
		GK *obj = new GK();
		obj->binaryValue = this->binaryValue - gray_decode(stoul(other, nullptr, 2));
		obj->gkValue = gray_encode(obj->binaryValue);
		return *obj;
	}

	GK & operator - (GK & other) {
		GK *obj = new GK();
		obj->binaryValue = this->binaryValue - this->binaryValue;
		obj->gkValue = gray_encode(obj->binaryValue);
		return *obj;
	}

	unsigned operator ++ () {
		++binaryValue;
		gkValue = gray_encode(binaryValue);
		return gkValue;
	}

	unsigned operator ++ (int) {
		auto temp = binaryValue;
		binaryValue += 1;
		gkValue = gray_encode(binaryValue);
		return gkValue;
	}

	unsigned operator -- () {
		--binaryValue;
		gkValue = gray_encode(binaryValue);
		return gkValue;
	}

	unsigned operator -- (int) {
		auto temp = binaryValue;
		binaryValue -= 1;
		gkValue = gray_encode(binaryValue);
		return gkValue;
	}

	GK & operator = (unsigned other) {
		this->setBinaryValue(other);
		this->setGkValue(gray_encode(binaryValue));
		return *this;
	}

	GK & operator = (cstr other) {
		this->setBinaryValue(strtoul(other, nullptr, 2));
		this->setGkValue(gray_encode(binaryValue));
		return *this;
	}

	unsigned operator * () {
		return gkValue;
	}

	string operator () () {
		return findDigitsInBinary(gkValue);
	}
};

GK & operator + (unsigned x, GK & other) {
	GK * obj = new GK();
	obj->setBinaryValue(x + other.getBinaryValue());
	obj->setGkValue(gray_encode(obj->getBinaryValue()));
	return *obj;
}

GK & operator + (cstr x, GK & other) {
	GK * obj = new GK();
	obj->setBinaryValue(gray_decode(stoul(x, nullptr, 2)) + other.getBinaryValue());
	obj->setGkValue(gray_encode(obj->getBinaryValue()));
	return *obj;
}

GK & operator - (unsigned x, GK & other) {
	GK * obj = new GK();
	obj->setBinaryValue(x - other.getBinaryValue());
	obj->setGkValue(gray_encode(obj->getBinaryValue()));
	return *obj;
}

GK & operator - (cstr x, GK & other) {
	GK * obj = new GK();
	obj->setBinaryValue(gray_decode(stoul(x, nullptr, 2)) - other.getBinaryValue());
	obj->setGkValue(gray_encode(obj->getBinaryValue()));
	return *obj;
}

ostream& operator << (ostream& os, GK& gk) {
	string res = findDigitsInBinary(gk.getGkValue());
	os << res << endl;
	return os;
}

int main() {

	unsigned u = 16u;
	GK a(31u), b(15u), c;
	cstr s = "10000";
	GK d(s);

	// GK + GK
	c = a + b;
	c();

	// GK + unsigned
	c = a + u;
	c();

	// unsigned + GK
	c = u + a;
	c();

	// GK + csrt
	c = a + s;
	c();

	// csrt + GK
	c = s + a;
	c();

	// GK - unsigned
	c = a - u;
	c();

	// GK - csrt
	c = a - s;
	c();

	// GK - GK
	c = a - b;
	c();

	// unsigned - GK
	c = u - b;
	c();

	// csrt - GK
	c = s - b;

	// ++GK
	++a;
	a();

	// GK++
	a++;
	a();

	// --GK
	--a;
	a();

	// GK--;
	a--;
	a();

	// GK = unsigned
	a = u;
	a();

	// GK = cstr
	a = s;
	a();

}