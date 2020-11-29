#include <iostream>
#include <pthread.h>
#include <fstream> 
#include <string>
using namespace std;

struct p {
	string name;
	ifstream jm;
	int namesInFile;
};

bool startWithAlpha = true;
string prefix;

void *filterName(void* arg) {
	char byte;
	int nameLength;
	startWithAlpha = true;
	p *par = (p*)arg;

	while (!par->jm.eof() && startWithAlpha) {
		par->jm.read(&byte, 1);
		nameLength = (int)byte;
		char *name = new char[nameLength + 1];
		par->jm.read(name, nameLength);
		name[nameLength] = '\0';
		string completeName = string(name);

		if (string(completeName).find(prefix) == 0) {
			par->namesInFile++;
		}
	}
	pthread_exit(0);
}

int main() {
	p param1;
	p param2;

	param1.name = "Jmena1b";
	param1.namesInFile = 0;
	param1.jm.open("Jmena1b", ios::binary);

	param2.name = "Jmena2b";
	param2.namesInFile = 0;
	param2.jm.open("Jmena2b", ios::binary);

	getline(cin, prefix);
	if (!isalpha(prefix[0])) {
		exit(0);
	}

	pthread_t thread1, thread2;
	pthread_create(&thread1, NULL, filterName, (void*)&param1);
	pthread_create(&thread2, NULL, filterName, (void*)&param2);

	pthread_join(thread1, NULL);
	pthread_join(thread2, NULL);

	cout << "Jmena1b count: " << param1.namesInFile << endl;
	cout << "Jmena2b count: " << param2.namesInFile << endl;

	param1.jm.close();
	param2.jm.close();
}