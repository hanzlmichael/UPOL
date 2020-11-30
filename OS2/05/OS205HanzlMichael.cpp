#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif
#include <Windows.h>
#include <assert.h>
#include <fstream>
#include <string>
#include <iostream>
#include <vector> 
#include <iomanip>
#include <algorithm>

using namespace std;


struct p
{
	ifstream input;
	fstream output;
	HANDLE SC;
	HANDLE SZ;
};

p parg;

int readNumbers = 0;
int writtenNumbers = 0;
int passingNum = 0;

DWORD WINAPI produce() {
	
	char x;
	unsigned char upperNibble;
	unsigned char lowerNibble;
	unsigned char mask = 15;
	string passing = "";

	while (parg.input.read(&x, 1)) {
		unsigned char c = (unsigned char)x;
		upperNibble = (c >> 4);
		lowerNibble = c & 15;

		if (upperNibble <= 9) {
			passing.append(to_string((int)upperNibble));
		}
		else {
			WaitForSingleObject(parg.SZ, INFINITE);
			passingNum = stoi(passing);
			ReleaseSemaphore(parg.SC, 1, NULL);
			readNumbers++;
			passing = to_string((int)lowerNibble);
			continue;
		}

		if (lowerNibble <= 9) {
			passing.append(to_string((int)lowerNibble));
		}
		else {
			WaitForSingleObject(parg.SZ, INFINITE);
			passingNum = stoi(passing);
			ReleaseSemaphore(parg.SC, 1, NULL);
			passing = "";
			readNumbers++;
			continue;
		}
	}
	WaitForSingleObject(parg.SZ, INFINITE);
	passingNum = INT_MIN;
	ReleaseSemaphore(parg.SC, 1, NULL);
	ExitThread(0);
}

DWORD WINAPI consume() {
	int numsOnLine = 1;

	while (true) {
		WaitForSingleObject(parg.SC, INFINITE);
		if (passingNum == INT_MIN) { ReleaseSemaphore(parg.SZ, 1, NULL); break; }
		parg.output << passingNum;
		parg.output << " ";
		ReleaseSemaphore(parg.SZ, 1, NULL);
		if (numsOnLine == 10) { parg.output << endl; numsOnLine = 0; }
		numsOnLine++;
		writtenNumbers++;		
	}
	ExitThread(0);
}


int main() {
	parg.SC = CreateSemaphore(NULL, 0, 1, NULL);
	parg.SZ = CreateSemaphore(NULL, 1, 1, NULL);
	parg.input.open("Cisla.bcd", ios::binary);
	parg.output.open("Cisla.txt", fstream::out);

	HANDLE h[2];
	HANDLE VC = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)produce, NULL, CREATE_SUSPENDED, NULL);
	HANDLE VZ = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)consume, NULL, CREATE_SUSPENDED, NULL);

	h[0] = VC;
	h[1] = VZ;

	assert(h[0] && h[1]);

	ResumeThread(h[0]);
	ResumeThread(h[1]);

	WaitForMultipleObjects(2, h, TRUE, INFINITE);

	CloseHandle(h[0]);
	CloseHandle(h[1]);
	CloseHandle(parg.SC);
	CloseHandle(parg.SZ);
	parg.input.close();
	parg.output.close();

	cout << "Prvni vlakno precetlo: " + to_string(readNumbers) + " cisel" << endl;
	cout << "Druhe vlakno zapsalo: " + to_string(writtenNumbers) + " cisel" << endl;
}