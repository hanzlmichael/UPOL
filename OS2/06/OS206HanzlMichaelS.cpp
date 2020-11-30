#include "pch.h"
#include <iostream>
#include <cstdlib>
#include <Windows.h>
#include <assert.h>
#include <iterator>
#include <algorithm>

using namespace std;

#define BUFFSIZE 512
LPCTSTR Roura = TEXT("\\\\.\\pipe\\MojeRoura");
bool isPalindrome(unsigned char str[]);

int main() {
	HANDLE h = CreateNamedPipe(Roura, PIPE_ACCESS_DUPLEX, PIPE_TYPE_MESSAGE | PIPE_WAIT, 1, BUFFSIZE, BUFFSIZE, 0, NULL);
	assert(h != INVALID_HANDLE_VALUE);
	DWORD read;
	DWORD written;
	LPVOID lpvMessage;
	unsigned char buff[BUFFSIZE];
	const char * answer;

	cout << "Waiting for client..." << endl;
	for (; !ConnectNamedPipe(h, NULL);) { ; }
	cout << "Client connected" << endl;

	while (true) {
		if (ReadFile(h, (LPVOID)buff, BUFFSIZE, &read, NULL)) {
			cout << "---------------------------------------" << endl;
			cout << "Received: " << buff << endl;
		}

		if (!isalnum(buff[0])) {
			CloseHandle(h);
			cout << "Server OUT" << endl;
			break;
		}
		else {
			if (isPalindrome(buff)) {
				answer = "Je palindrom\n";
			}
			else {
				answer = "Neni palindrom\n";
			}
			lpvMessage = (LPVOID)answer;
			WriteFile(h, (LPVOID)lpvMessage, (DWORD)(strlen((const char *)lpvMessage) + 1), &written, NULL);
		}		
	}	
}

bool isPalindrome(unsigned char str[]) {
	string s((char*)str);
	s.erase(remove_if(s.begin(), s.end(), [](char c) { return c < 0 || !isalnum(c); }), s.end());
	transform(s.begin(), s.end(), s.begin(), ::tolower);
	return (s == string(s.rbegin(), s.rend()));
}