#include "pch.h"
#include <iostream>
#include <cstdlib>
#include <Windows.h>
#include <assert.h>

#define BUFFSIZE 512
using namespace std;

int main() {
	HANDLE h;
	LPVOID lpvMessage;
	unsigned char buff[BUFFSIZE];
	DWORD read, written;
	LPCTSTR Roura = TEXT("\\\\.\\pipe\\MojeRoura");
	unsigned char *input = new unsigned char[BUFFSIZE];

	h = CreateFile(Roura, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL);

	while (true) {
		getline(cin, input);
		//cin >> input;
		lpvMessage = (LPVOID)input;

		WriteFile(h, lpvMessage, strlen((const char *)lpvMessage) + 1, &written, NULL);

		if (!isalnum(input[0])) {
			break;
		}

		ReadFile(h, (LPVOID)buff, BUFFSIZE, &read, NULL);

		cout << buff << endl;		
	}
	CloseHandle(h);
	return 0;
}
