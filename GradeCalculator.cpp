/*
* Description: This program test the Scores, Percentage, and Grade classes
* Inputs: Number of scores and each score
* Outputs: Scores, total percentage, and grade
* By: Tyler Tucker
*/

#include <iostream>
#include <cmath>
using namespace std;

class Scores {
protected:
    int numScores;
    double* scores;

public:
    void getScores();
    virtual void print();
    virtual ~Scores();
};

class Percentage : public Scores {
protected:
    double percentage;

public:
    void calcPercentage();
    void print() override;
};

class Grade : public Percentage {
private:
    string grade;

public:
    void calcGrade();
    void print() override;
};

int main() {
    Grade grade;
    grade.getScores();
    grade.calcPercentage();
    grade.calcGrade();
    grade.print();

    return 0;
}


Scores::~Scores() {
    delete[] scores;
}

void Scores::getScores() {
    cout << "How many scores would you like to enter? ";
    cin >> numScores;
    scores = new double[numScores];
    cout << "Enter " << numScores << " scores separated by a space: ";
    for (int i = 0; i < numScores; i++) {
        cin >> scores[i];
    }
}

void Scores::print() {
    cout << "Assignment Scores:\n";
    for (int i = 0; i < numScores; i++) {
        cout << "Assignment " << i + 1 << ": " << scores[i] << endl;
    }
}

void Percentage::calcPercentage() {
    double sum = 0;
    for (int i = 0; i < numScores; i++) {
        sum += scores[i];
    }
    percentage = round((sum / numScores) * 10.0) / 10.0;
}

void Percentage::print() {
    Scores::print();
    cout << "Total Percentage: " << percentage << "%" << endl;
}

void Grade::calcGrade() {
    if (percentage >= 90) grade = "A";
    else if (percentage >= 87) grade = "A-";
    else if (percentage >= 84) grade = "B+";
    else if (percentage >= 80) grade = "B";
    else if (percentage >= 77) grade = "B-";
    else if (percentage >= 74) grade = "C+";
    else if (percentage >= 70) grade = "C";
    else if (percentage >= 67) grade = "C-";
    else if (percentage >= 64) grade = "D+";
    else if (percentage >= 60) grade = "D";
    else if (percentage >= 57) grade = "D-";
    else grade = "E";
}

void Grade::print() {
    Percentage::print();
    cout << "Final Grade: " << grade << endl;
}