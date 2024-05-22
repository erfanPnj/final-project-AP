# A University manager app made by Java and Dart (Flutter framework)
The backend is developed using Java and Dart is used for frontend.
## Backend contains 5 classes:
this classes were previously written in [miniProject repo](https://github.com/erfanPnj/miniProject/)
### Student.java:
```
This class provides attributes and methods related to a student, like his/her name, student Id and etc.
Each student has a unique Id but of course, they can share a name!
```
### Teacher.java:
```
This class defines a teacher and related courses. A teacher can rate students, define an assignment
Teacher class objects have methods to achieve these tasks.
```
### Course.java:
```
A course has a teacher and some students (List) and also assignments.
```
### Assignment.java:
```
Assignments are considered to be defined by teachers, so define assignment method in Teacher.java is used
to create a new object of this class.
```
### Faculty.java:
```
This class provide 4 lists, list of students, teachers, courses and assignments which are used to keep 
everything wrapped in a kinda separated class.
```
