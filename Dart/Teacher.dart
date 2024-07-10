import 'Course.dart';

class Teacher {
  final String name;
  final String id;
  final int presentedCoursesCount;
  List<Course> presentedCourses = [];

  Teacher(this.name, this.id, this.presentedCoursesCount);

  void addCourseToThisTeacher(Course course) {}
}