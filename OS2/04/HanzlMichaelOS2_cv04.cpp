#include <windows.h>
#include <assert.h>
#include <fstream>
#include <string>
#include <iostream>
#include <vector> 
#include <iomanip>
#include <string>
using namespace std;

// GLOBALS 

ifstream fileToProcess("Jazyk C++.txt");

string chars;

int occurrences[26] = { 0 };

CRITICAL_SECTION A;
CRITICAL_SECTION B;

// FUN PROTOTYPES

void printValues();
char positionInChars(char input);
bool isFromAlphabet(char c);
bool findInCP1250(char c);

//--------------------------------------------------------------------------------------------------------------------

DWORD WINAPI calculateOccurrences() {
	char data;
	while (true) {
		EnterCriticalSection(&A);
		fileToProcess >> data;
		if (fileToProcess.eof()) {
			LeaveCriticalSection(&A);
			break;
		}
		LeaveCriticalSection(&A);
		if (findInCP1250(data)) {
			data = positionInChars(data);
		}

		if (isFromAlphabet(data)) {
			char result = toupper(data);
			int position = (int)result - 65;
			EnterCriticalSection(&B);
			occurrences[position]++;
			LeaveCriticalSection(&B);
		}
	}
	ExitThread(0);
}

//--------------------------------------------------------------------------------------------------------------------
int main() {

	ifstream cp1250("CP-1250");

	while (!cp1250.eof()) {
		getline(cp1250, chars);
	}
	cp1250.close();

	HANDLE h[2];

	h[0] = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)calculateOccurrences, NULL, CREATE_SUSPENDED, NULL);
	h[1] = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)calculateOccurrences, NULL, CREATE_SUSPENDED, NULL);

	assert(h[0] && h[1]);
	InitializeCriticalSection(&A);
	InitializeCriticalSection(&B);

	ResumeThread(h[0]);
	ResumeThread(h[1]);

	WaitForMultipleObjects(2, h, TRUE, INFINITE);

	CloseHandle(h[0]);
	CloseHandle(h[1]);

	DeleteCriticalSection(&A);
	DeleteCriticalSection(&B);

	printValues();

	fileToProcess.close();
	cout << endl;
}

//--------------------------------------------------------------------------------------------------------------------

// FUN DEFINES

void printValues() {
	int count = 0;
	for (int i = 0; i < 26; i++) {
		int ascii;
		if (count == 5) {
			ascii = i + 65;
			cout << endl << (char)ascii << setw(6) << occurrences[i];
			cout << "     ";
			count = 1;
		}
		else {
			ascii = i + 65;
			cout << (char)ascii << setw(6) << occurrences[i];
			cout << "     ";
			count++;
		}
	}
}

char positionInChars(char input) {
	for (unsigned i = 0; i < chars.length(); i += 2) {
		if (input == chars[i]) return chars[i + 1];
	}
	return NULL;
}

bool findInCP1250(char c) {
	for (unsigned i = 0; i < chars.length(); i += 2) {
		if (c == chars[i]) return true;
	}
	return false;
}

bool isFromAlphabet(char c) {
	return ((c >= 97 && c <= 122) || (c >= 65 && c <= 90) || findInCP1250(c));
}