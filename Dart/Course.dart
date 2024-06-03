import 'dart:core';
import 'Assignment.dart';
import 'Student.dart';
import 'Teacher.dart';

class Course{
  final String courseName;
  final Teacher courseTeacher;
  final int countOfUnits;
  List<Student> studentList = [];
  bool status;
  int countOfAssignments = 0;
  final String examDate; // it must be a string in the format of Year.Month.Day: 2024.4.10;
  List<Assignment> activeProjects = [];
  List<Assignment> deactiveProjects = [];
  int presentedSemester;
  Map<Student, double> scores = {};

  Course(this.courseName, this.courseTeacher, this.countOfUnits, this.examDate, this.presentedSemester, this.status) {
    if (!courseTeacher.presentedCourses.contains(this)) {
      courseTeacher.addCourseToThisTeacher(this);
    }
  }
}