#include <iostream>
#include <limits.h>
#include <conio.h>
#include <cmath>
#define pi = 3.14
using namespace std;

extern "C"
{
	float prog1(float);
	float prog2(float);
}

extern "C" float result;

float task1(float x)
{
	float b = 0.0;
	b = (2 / (tan(pow(x, 2))) + ((pow(2, (x * sin(sqrt(3 * pow(x, 2) + 1))))) / (sin(x) * cos(x) * log2(sqrt(pow(x, 2) + 1)))));
	return b;
}

float task2(float x)
{
	float f;
	if (x < 0)
	{
		f = pow(cos(x), 4);
	}
	if (x <= 0.5 and x >= 0)
	{
		f = pow(2, x) - 7;
	}
	if (x > 0.5)
	{
		f = (pow(x, 2) + 1) * (x - 1);
	}
	return f;
}

int main()
{
	setlocale(LC_ALL, "rus");
	int selector;
	float x;
	do
	{
		cout << "1 - ������ �������" << endl;
		cout << "2 - ������ �������" << endl;
		cout << "0 - �����" << endl;
		cin >> selector;
		switch (selector)
		{
		case 1:
			cout << "������� x: ";
			cin >> x;
			cout << "������� 1 �� c++: " << task1(x) << endl;
			cout << "������� 1 �� assembler: " << prog1(x) << endl;
			break;
		case 2:
			cout << "������� x: ";
			cin >> x;
			cout << "������� 2 �� c++: " << task2(x) << endl;
			cout << "������� 2 �� assembler: " << prog2(x) << endl;
			break;
		case 0:
			break;
		default:
			break;
		}
	} while (selector != 0);
}
