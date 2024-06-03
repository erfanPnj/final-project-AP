import 'dart:collection';

import 'Assignment.dart';
import 'Course.dart';
import 'Student.dart';
import 'Teacher.dart';

class Faculty {
  static int? _semester;
  static final List<Student> _students = [];
  static final List<Teacher> _teachers = [];
  static final List<Course> _courses = [];
  static final List<Assignment> _assignments = [];

  Faculty(String name, int semester) {
    _semester = semester;
  }

  void setSemester(int semester) {
    _semester = semester;
  }

  static int? get semester => _semester;

  static List<Student> get students => _students;

  static List<Teacher> get teachers => _teachers;

  static List<Course> get courses => _courses;

  static List<Assignment> get assignments => _assignments;
}