import 'dart:core';
import 'Assignment.dart';
import 'Student.dart';
import 'Teacher.dart';

class Course{
  final String courseName;
  final Teacher courseTeacher;
  final int countOfUnits;
  final String courseId;
  List<Student> studentList = [];
  bool status; // is it active or not
  int countOfAssignments = 0;
  final String examDate; // it must be a string in the format of Year.Month.Day: 2024.4.10;
  List<Assignment> activeProjects = [];
  List<Assignment> deactiveProjects = [];
  int presentedSemester;
  Map<Student, double> scores = {};
  //int get countOfAssignment => countOfAssignments;

  Course(this.courseName, this.courseTeacher, this.countOfUnits, this.examDate, this.presentedSemester, this.status, this.courseId, this.countOfAssignments) {
    if (!courseTeacher.presentedCourses.contains(this)) {
      courseTeacher.addCourseToThisTeacher(this);
    }
  }
}