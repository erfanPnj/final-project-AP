import 'Course.dart';

class Student {
  final String name;
  final String studentId;
  final String password;
  int countOfCourses = 0;
  int countOfUnits = 0;
  final List<Course> courses = [];
  double allOfPoints = 0;
  double thisSemesterPoints = 0;
  double countOfAllOfGrades = 0;
  double countOfThisSemesterGrades = 0;

  Student(this.name, this.studentId, this.password);
}