/*
* Description: Basic calculator 
* Inputs: Numbers and choices
* Outputs: Solutions to the operations inputted
* By: Tyler Tucker
*/

#include <iostream>
using namespace std;

//make calc class
class Calculator {
	//establish private varables for class
private:
	double values[4];
	int nums;
	double ans;
public:
	Calculator();
	void add();
	void subtract();
	void mult();
	void divide();
	void newNum(double num);
	void clear();
};


int main() {
	//creates calculator variable
	Calculator calculator;
	//asks input
	cout << "CALCULATOR\nWhat would you like to do?\n";
	char choice = 'o';
	bool cont = true;
	while (cont) {
		double number = 0;
		//displays options
		cout << "\ne) Enter number\na) Add\ns) Subtract\nm) Multiply\nd) Divide\nc) Clear calculator\nq) Quit";

		//gets choice
		cout << "\n\nChoice: ";
		cin >> choice;

		//goes to whatever option is inputted

		//gets new number for calculator
		if (choice == 'e') {
			cout << "\nEnter a number into calculator: ";
			cin >> number;
			calculator.newNum(number);
		}
		//adds all numbers together
		else if (choice == 'a') {
			calculator.add();
		}
		//subtracts other numbers from first inputted number
		else if (choice == 's') {
			calculator.subtract();
		}
		//multiplies all numbers together
		else if (choice == 'm') {
			calculator.mult();
		}
		//divides first nuber inputted by all those following
		else if (choice == 'd') {
			calculator.divide();
		}
		//clears calc
		else if (choice == 'c') {
			calculator.clear();
			cout << "\nAll values are cleared!" << endl;
		}
		//ends while loop
		else if (choice == 'q') {
			cont = false;
		}
		//if input isnt listed, states error message
		else {
			cout << "\nInvalid input. Try again!\n";
		}
	}
	//quit message
	cout << "\nQuitting...Goodbye!";
	return 0;
}

//when calculator variable is made, starting values are 0
Calculator::Calculator() {
	for (int i = 0;i < 4;i++) {
		values[i] = 0;
	}
	nums = 0;
	ans = 0;
}

//add function
void Calculator::add() {
	
	//if less than 2 numbers says error message
	if (nums < 2){
		cout << "\nEnter at least 2 numbers for calculation!\n";
	}

	//if 2 or more nums, does function
	else {
		//creates tempAns variable to use for later
		double tempAns = 0;
		cout << endl;

		//makes ans equal to first number in values
		ans = values[0];

		//goes through values and adds them to ans
		for (int i = 1; i < nums; i++) {
			ans += values[i];
		}

		//prints out numbers and what they equaled after operation
		cout << values[0];
		for (int i = 1; i < nums; i++) {
			cout << " + " << values[i];
		}
		cout << " = " << ans << endl;

		//clears values while still making first value equal to answer
		tempAns = ans;
		clear();
		values[0] = tempAns;
		nums = 1;
	}


}

void Calculator::subtract() {
	//if less than 2 numbers says error message
	if (nums < 2) {
		cout << "\nEnter at least 2 numbers for calculation!\n";
	}

	//if 2 or more nums, does function
	else {
		//creates tempAns variable to use for later
		double tempAns = 0;
		cout << endl;

		//makes ans equal to first number in values
		ans = values[0];

		//goes through and subtracts them from ans
		for (int i = 1; i < nums; i++) {
			ans -= values[i];
		}

		//prints out numbers and what they equaled after operation
		cout << values[0];
		for (int i = 1; i < nums; i++) {
			cout << " - " << values[i];
		}
		cout << " = " << ans << endl;

		//clears values while still making first value equal to answer
		tempAns = ans;
		clear();
		values[0] = tempAns;
		nums = 1;
	}

}

void Calculator::mult() {
	//if less than 2 numbers says error message
	if (nums < 2) {
		cout << "\nEnter at least 2 numbers for calculation!\n";
	}

	//if 2 or more nums, does function
	else {
		//creates tempAns variable to use for later
		double tempAns = 0;
		cout << endl;

		//makes ans equal to first number in values
		ans = values[0];

		//goes through values and multiplies them to ans
		for (int i = 1; i < nums; i++) {
			ans *= values[i];
		}

		//prints out numbers and what they equaled after operation
		cout << values[0];
		for (int i = 1; i < nums; i++) {
			cout << " * " << values[i];
		}
		cout << " = " << ans << endl;

		//clears values while still making first value equal to answer
		tempAns = ans;
		clear();
		values[0] = tempAns;
		nums = 1;
	}

}

void Calculator::divide() {
	//if less than 2 numbers says error message
	if (nums < 2) {
		cout << "\nEnter at least 2 numbers for calculation!\n";
	}

	//if 2 or more nums, does function
	else {
		//creates tempAns variable to use for later
		double tempAns = 0;
		cout << endl;

		//makes ans equal to first number in values
		ans = values[0];

		//goes through values and divides ans by them
		for (int i = 1; i < nums; i++) {
			ans /= values[i];
		}

		//prints out numbers and what they equaled after operation
		cout << values[0];
		for (int i = 1; i < nums; i++) {
			cout << " / " << values[i];
		}
		cout << " = " << ans << endl;

		//clears values while still making first value equal to answer
		tempAns = ans;
		clear();
		values[0] = tempAns;
		nums = 1;
	}

}

void Calculator::newNum(double num) {
	//prints error message if over value limit
	if (nums >= 4) {
		cout << "\nFailed to enter the current number!\nNo room left for a new number!\n";
	}
	//if not over limit, adds number to values
	else {
		values[nums] = num;
		nums++;
	}
}


void Calculator::clear() {
	//sets all values in calculator to 0
	for (int i = 0;i < 4;i++) {
		values[i] = 0;
	}
	nums = 0;
	ans = 0;
}


