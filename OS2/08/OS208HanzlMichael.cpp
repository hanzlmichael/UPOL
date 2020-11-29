#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif

#include <iostream>
#include <pthread.h>
#include <unistd.h>

using namespace std;

pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;
bool compareTime();
time_t t = 0;
time_t lastTime = 0;
int counter = 0;
bool exitThread = false;
char buffer[20];

void *generateTime(void* p) {
	for (;;) {
		pthread_mutex_lock(&mtx);
		if (exitThread) {
			pthread_mutex_unlock(&mtx);
			break;
		}

		time(&t);
		pthread_mutex_unlock(&mtx);
		usleep(50000);
	}
	pthread_exit(0);
}

void *printTime(void* p) {
	for (;;) {
		pthread_mutex_lock(&mtx);

		if (counter < 5) {
			if (lastTime != 0 && !compareTime()) {
				tm * tm_local = localtime(&t);
				tm_local->tm_hour += 1;
				strftime(buffer, 20, "%H:%M:%S", tm_local);
				cout << buffer << endl;
				lastTime = t;
				counter++;
			}
			if (lastTime == 0 && t != 0) {
				tm * tm_local = localtime(&t);
				tm_local->tm_hour += 1;
				strftime(buffer, 20, "%H:%M:%S", tm_local);
				cout << buffer << endl;
				lastTime = t;
				counter++;
			}
		}
		else {
			exitThread = true;
			pthread_mutex_unlock(&mtx);
			break;
		}

		pthread_mutex_unlock(&mtx);
		usleep(50000);
	}
	pthread_exit(0);
}

bool compareTime() {
	int h1, m1, s1, h2, m2, s2;

	tm *tm_last = localtime(&t);
	h1 = tm_last->tm_hour;
	m1 = tm_last->tm_min;
	s1 = tm_last->tm_sec;

	tm *tm_now = localtime(&lastTime);
	h2 = tm_now->tm_hour;
	m2 = tm_now->tm_min;
	s2 = tm_now->tm_sec;

	return h1 == h2 && m1 == m2 && s1 == s2;
}

int main() {

	pthread_t thread1, thread2;
	pthread_create(&thread1, NULL, generateTime, (void*)NULL);
	pthread_create(&thread2, NULL, printTime, (void*)NULL);

	pthread_join(thread1, NULL);
	pthread_join(thread2, NULL);

	cout << "Threads ended" << endl;
}
