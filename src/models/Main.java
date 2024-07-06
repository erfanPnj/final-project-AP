package models;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

import static java.lang.System.*;

public class Main {
    static void clearScreen() {
        out.print("\033[H\033[2J");
        out.flush();
    } // which does not work in IDE's terminal!

    static int userInput; // this variable is static to be accessible in server related classes

    // we need to delete data from .txt files after performing a removal activity:
    public static void removeLineFromFile(String filePath, String... clue) throws IOException {
        File file = new File(filePath);
        Scanner scanner = new Scanner(file);
        String lineToRemove = "";

        while (scanner.hasNextLine()) {
            String previouslyReadLine = scanner.nextLine();
            int status = 0;
            for (String c : clue) {
                if (previouslyReadLine.contains(c))
                    status++;
            }
            if (status == clue.length) {
                lineToRemove += previouslyReadLine;
                break;
            }
        }

        Path path = Paths.get(filePath);
        List<String> lines = Files.readAllLines(path);
        // Create a new list to store lines except the one to remove
        List<String> updatedLines = new ArrayList<>();

        // Add all lines except the line to remove
        for (String line : lines) {
            if (!line.trim().equals(lineToRemove.trim())) {
                updatedLines.add(line);
            }
        }

        // Write the updated lines back to the file
        Files.write(path, updatedLines);
        out.println("DONE...!");
    }

    static void showTeacherMenu() {
        out.println("1. Show my courses.");
        out.println("2. Add student to a course.");
        out.println("3. Remove student from a course.");
        out.println("4. Define new assignment.");
        out.println("5. Delete an existing assignment.");
        out.println("6. Rate a student in a course.");
        out.println("7. Change the deadline of an assignment.");
        out.println("8. Exit.");
    }

    static void showAdminMenu() {
        out.println("1. Add a new teacher.");
        out.println("2. Add student to a course.");
        out.println("3. Remove student from a course.");
        out.println("4. Delete a course.");
        out.println("5. Define new assignment.");
        out.println("6. Delete an existing assignment.");
        out.println("7. Change the deadline of an assignment.");
        out.println("8. Rate a student.");
        out.println("9. Show an student's courses list.");
        out.println("10. Show an student's average.");
        out.println("11. Exit.");
    }

    public static void writeData(String data, String filePath) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
            writer.write(data);
            writer.newLine();
        } catch (IOException e) {
            err.println("An error occurred while reading from source!");
        }
    }

    public static void loadTeacherData(List<Teacher> list) throws FileNotFoundException {
        File file = new File("src/models/teachers.txt");
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String data = scanner.nextLine();
            String[] parts;
            parts = data.split("~");
            Teacher teacher = new Teacher(parts[0], parts[1], Integer.parseInt(parts[2]));
            list.add(teacher);
        }
    }

    public static void loadCourseData(List<Course> list) throws IOException {
        // we need teachers data first, so we load it right here:
        loadTeacherData(Faculty.getTeachers());
        File file = new File("src/models/courses.txt");
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String data = scanner.nextLine();
            String[] parts;
            parts = data.split("~");

            for (Teacher t : Faculty.getTeachers()) {
                if (t.getId().equals(parts[1])) {
                    if (parts[4].equals("true")) {
                        list.add(new Course(parts[0], t, Integer.parseInt(parts[2]), parts[3], Faculty.getSemester(), true, parts[5]));
                        // update teachers data after adding course
                    } else {
                        list.add(new Course(parts[0], t, Integer.parseInt(parts[2]), parts[3], Faculty.getSemester(), false, parts[5]));
                    }
                    removeLineFromFile("src/models/teachers.txt", t.getId());
                    writeData(t.toString(), "src/models/teachers.txt");
                    break;
                }
            }
        }
    }

    public static void loadStudentData(List<Student> list) throws IOException {
        // we need courses data first, so we load it here and by doing this, we have also loaded teachers data!
        loadCourseData(Faculty.getCourses());
        File file = new File("src/models/students.txt");
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String data = scanner.nextLine();
            String[] parts;
            parts = data.split("~");
            Student student = new Student(parts[0], parts[1], parts[2]);
            if (parts.length >= 4) { // in case the student is not attended to any course, like Erfan-2222 (there is no parts[2])
                for (int i = 3; i < parts.length; i++) {
                    if (parts[i].contains("/")) {
                        String[] courseGradePair = parts[i].split("/");
                        for (Course c : Faculty.getCourses()) {
                            if (courseGradePair[0].equals(c.getCourseId())) {
                                student.addCourseAndUnit(c);

                                // this grade should also be added to allOfPoints and count of points should increase by 1:
                                student.setAllOfPoints(student.getAllOfPoints() + Double.parseDouble(courseGradePair[1]));
                                student.setCountOfAllOfGrades(student.getCountOfAllOfGrades() + 1);

                                if (c.getPresentedSemester() == Faculty.getSemester()) {
                                    // and if this course is for this semester the grade is also added to this semester grades:
                                    student.setThisSemesterPoints(student.getThisSemesterPoints() + Double.parseDouble(courseGradePair[1]));
                                    student.setCountOfThisSemesterGrades(student.getCountOfThisSemesterGrades() + 1);
                                }

                                c.getScores().put(student, Double.valueOf(courseGradePair[1]));
                            }
                        }
                    }
                }
            }
            list.add(student);
        }
    }

    public static void loadAssignmentData(List<Assignment> list) throws IOException {
        loadStudentData(Faculty.getStudents());
        File file = new File("src//models/assignments.txt");
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String data = scanner.nextLine();
            String[] parts;
            parts = data.split("~");
            if (parts[2].equals("true")) {
                list.add(new Assignment(parts[0], Integer.parseInt(parts[1]), true, parts[3]));
            } else {
                list.add(new Assignment(parts[0], Integer.parseInt(parts[1]), false, parts[3]));
            }
            for (Course course: Faculty.getCourses()) {
                if (course.getCourseId().equals(parts[3])) {
                    course.setCountOfAssignments(course.getCountOfAssignments() + 1);
                }
            }
        }
    }

    static void singUp (String studentData) {
        String[] parts = studentData.split("-");
        Student student = new Student(parts[0], parts[1], parts[2]);

        writeData(student.toString(), "src/models/students.txt");
        Faculty.getStudents().add(student);
    }

    static Student login (String studentId, String studentPassword) {
        for (Student s : Faculty.getStudents()) {
            if (s.getId().equals(studentId) && s.getPassword().equals(studentPassword)) {
                return s;
            }
        }
        // then we check if the student's password is equal to the string "null", this is not a registered student
        return new Student("null", "null", "null");
    }

    static boolean isThisYourCourse(String courseId, String teacherId, String errorMessage) {
        List<String> courseIds = new ArrayList<>();

        boolean isThisYourCourse = true;
        for (Course c : Faculty.getCourses()) {
            courseIds.add(c.getCourseId());
            if (c.getCourseId().equals(courseId)) {
                if (!c.getCourseTeacher().getId().equals(teacherId)) {
                    out.println(errorMessage);
                    isThisYourCourse = false;
                }
            }
        }

        if (!courseIds.contains(courseId)) {
            out.println("There isn't any course with this id!");
            return false;
        }
        return isThisYourCourse;
    }

    public static List<String> sendStudentData(String studentId) throws IOException {
        File file = new File("src/models/students.txt");
        Scanner scanner = new Scanner(file);
        List<String> parts = new ArrayList<>();

        while (scanner.hasNextLine()) {
            String previouslyReadLine = scanner.nextLine();
            if (previouslyReadLine.contains(studentId)) {
                parts = List.of(previouslyReadLine.split("~"));
            }
        }
        return parts;
    }

    public static List<String> sendCourseData (List<String> list) throws IOException {
        File coursesFile = new File("src/models/courses.txt");
        Scanner scanner = new Scanner(coursesFile);
        List<String> courses = new ArrayList<>();
        String previouslyReadLine;

        while (scanner.hasNextLine()) {
            previouslyReadLine = scanner.nextLine();
            for (String s: list) {
                if (previouslyReadLine.contains(s)) {
                    for (Teacher t: Faculty.getTeachers()) {
                        if (previouslyReadLine.contains(t.getId())) {
                            StringBuilder countOfAssignments = new StringBuilder();
                            for (Course course: Faculty.getCourses()) {
                                if (course.getCourseId().equals(s)) {
                                    countOfAssignments.append(course.getCountOfAssignments());
                                }
                            }
                            // form the response and prepare it to send it to flutter
                            courses.add(previouslyReadLine + "~" + countOfAssignments + "|" + t);
                        }
                    }
                }
            }

        }
        scanner.close();
        return courses;
    }

    public static void main(String[] args) throws IOException {
        new Faculty("computerEngineering", 2);
        // After each launch of the program, we need to load the data from text files:
        Main.loadStudentData(Faculty.getStudents()); // also loads teachers data and courses data
        Main.loadAssignmentData(Faculty.getAssignments());
        out.println("Welcome to DaneshjooYar!\nPlease choose your roll:\n1. Teacher\n2. Admin");
        Scanner scanner = new Scanner(in);

        userInput = scanner.nextInt();

        switch (userInput) {
            case 1: {
                out.println("Please enter your name:");
                Scanner scanner1 = new Scanner(in);
                String teacherName = scanner1.nextLine();
                int isTeacherRegistered = 0;
                for (Teacher t : Faculty.getTeachers()) {
                    if (t.getName().equalsIgnoreCase(teacherName))
                        isTeacherRegistered++;
                }
                if (isTeacherRegistered == 0) {
                    out.println("You are not registered in this faculty, please contact the admin for registration.");
                    break;
                }
                out.println("Please enter your teacher ID:");
                Scanner scanner2 = new Scanner(in);
                String teacherId = scanner2.nextLine();

                boolean isPasswordCorrect = false;

                for (Teacher t : Faculty.getTeachers()) {
                    if (t.getId().equals(teacherId)) {
                        isPasswordCorrect = true;
                        break;
                    }
                    if (!t.getId().equals(teacherId) && t.getName().equals(teacherName)) {
                        for (int i = 0; i < 3; i++) {
                            out.println("Wrong Id! try again (" + (3 - i) + " chance(s) left)");
                            teacherId = scanner2.nextLine();
                            if (teacherId.equals(t.getId())) {
                                isPasswordCorrect = true;
                                break;
                            }
                        }
                    }
                }

                if (!isPasswordCorrect) {
                    out.println("you've entered wrong id several times!");
                    break;
                }

                out.println("Welcome!\n\n");
                while (userInput != 8) {
                    showTeacherMenu();
                    userInput = scanner.nextInt();
                    switch (userInput) {
                        case 1: {
                            for (Course c : Faculty.getCourses()) {
                                if (c.getCourseTeacher().getId().equals(teacherId)) {
                                    out.println(c.getCourseName());
                                }
                            }
                        }
                        break;
                        case 2: {
                            Scanner scanner3 = new Scanner(in);
                            String studentName = "";
                            out.println("What's the student's ID?");
                            Scanner scanner4 = new Scanner(in);
                            String studentId = scanner4.nextLine();
                            out.println("What's the target course's ID?");
                            Scanner scanner5 = new Scanner(in);
                            String courseId = scanner5.nextLine();

                            boolean isThisYourCourse = isThisYourCourse(courseId, teacherId,
                                    "You cannot add student to a course you don't have!");

                            //if it's not your course, then you cannot add a student :)
                            if (!isThisYourCourse) {
                                break;
                            }

                            int isAlreadyWritten = 0;
                            for (Student s : Faculty.getStudents()) {
                                if (s.getId().equals(studentId)) { // student is already in file, so we want to overwrite it
                                    removeLineFromFile("src/models/students.txt", studentId); // remove the previous data
                                    for (Course c : Faculty.getCourses()) {
                                        if (c.getCourseId().equals(courseId)) {
                                            isAlreadyWritten = 1; // we found the target
                                            s.addCourseAndUnit(c);
                                            writeData(s.toString() + "/0.0", "src/models/students.txt"); // write the updated data to file
                                            out.println("Done!");
                                            break;
                                        }
                                    }
                                    break;
                                }
                            }

                            if (isAlreadyWritten == 0) {
                                // If this is a new student, we create a new object (student) and add
                                for (Student student: Faculty.getStudents()) {
                                    if (student.getId().equals(studentId)) {
                                        studentName = student.getName();
                                    }
                                }
                                // it to course and also the text file
                                Student student = new Student(studentName, studentId, "@" + studentId); // @ + student ID is a default password
                                for (Course c : Faculty.getCourses()) {
                                    if (c.getCourseId().equals(courseId)) {
                                        c.addStudent(student);
                                        writeData(student.toString(), "src/models/students.txt"); // save the student to students.txt
                                        out.println("Done!");
                                        break;
                                    }
                                }
                            }
                        }
                        break;
                        case 3: {
                            String studentName = "";
                            out.println("What's the student's ID?");
                            Scanner scanner4 = new Scanner(in);
                            String studentId = scanner4.nextLine();
                            out.println("What's the course ID?");
                            Scanner scanner5 = new Scanner(in);
                            String courseId = scanner5.nextLine();

                            boolean isThisYourCourse = isThisYourCourse(courseId, teacherId,
                                    "You cannot remove student from a course you don't have!");

                            //if it's not your course, then you cannot add a student :)
                            if (!isThisYourCourse) {
                                break;
                            }

                            for (Course c : Faculty.getCourses()) {
                                if (c.getCourseId().equals(courseId) && c.getCourseTeacher().getId().equals(teacherId)) {
                                    removeLineFromFile("src/models/students.txt", studentId);
                                    for (Student s : Faculty.getStudents()) {
                                        if (s.getId().equals(studentId)) {
                                            c.eliminateStudent(s);
                                            writeData(s.toString(), "src/models/students.txt");
                                        }
                                    }
                                    break;
                                }
                            }
                        }
                        break;
                        case 4: {
                            out.println("Great! for which course do you wanna define a new assignment? (enter course id)");
                            Scanner scanner3 = new Scanner(in);
                            String courseId = scanner3.nextLine();

                            boolean isThisYourCourse = isThisYourCourse(courseId, teacherId,
                                    "You cannot define an assignment for a course you don't have!");

                            //if it's not your course, then you cannot add a student :)
                            if (!isThisYourCourse) {
                                break;
                            }

                            out.println("What would you call your newly defined assignment?");
                            Scanner scanner4 = new Scanner(in);
                            String assignmentName = scanner4.nextLine();
                            out.println("How many days have you considered until deadline?");
                            Scanner scanner5 = new Scanner(in);
                            int deadline = scanner5.nextInt();

                            for (Course c : Faculty.getCourses()) {
                                if (c.getCourseTeacher().getId().equals(teacherId) && c.getCourseId().equalsIgnoreCase(courseId)) {
                                    Assignment assignment = new Assignment(assignmentName, deadline, true, courseId);
                                    writeData(assignment.toString(), "src/models/assignments.txt");
                                    c.getCourseTeacher().defineNewAssignment(c.getCourseId(), assignmentName, true, deadline);
                                    break;
                                }
                            }
                        }
                        break;
                        case 5: {
                            out.println("From what course do you want to delete an assignment? (enter course id)");
                            Scanner scanner3 = new Scanner(in);
                            String courseId = scanner3.nextLine();

                            boolean isCourseForTeacher = isThisYourCourse(courseId, teacherId,
                                    "You cannot delete an assignment from a course that's not yours!");

                            if (!isCourseForTeacher) {
                                break;
                            }

                            out.println("Ok! What is the name of the assignment you want to delete?");
                            Scanner scanner4 = new Scanner(in);
                            String assignmentName = scanner4.nextLine();

                            for (Course c : Faculty.getCourses()) {
                                if (c.getCourseTeacher().getId().equals(teacherId) && c.getCourseId().equalsIgnoreCase(courseId)) {
                                    removeLineFromFile("src/models/assignments.txt", assignmentName, courseId);
                                    c.getCourseTeacher().deleteAnAssignment(c.getCourseId(), assignmentName);
                                    break;
                                }
                            }
                        }
                        break;
                        case 6: {
                            out.println("What's the student's ID?");
                            Scanner scanner3 = new Scanner(in);
                            String studentId = scanner3.nextLine();
                            out.println("In what course do you want to rate this student?");
                            Scanner scanner4 = new Scanner(in);
                            String courseId = scanner4.nextLine();

                            boolean isThisYourCourse = isThisYourCourse(courseId, teacherId,
                                    "You cannot rate a student in a course you don't have!");

                            //if it's not your course, then you cannot add a student :)
                            if (!isThisYourCourse) {
                                break;
                            }

                            out.println("What's the grade?");
                            Scanner scanner5 = new Scanner(in);
                            double grade = scanner5.nextDouble();

                            for (Course c : Faculty.getCourses()) {
                                if (c.getCourseTeacher().getId().equals(teacherId) && c.getCourseId().equalsIgnoreCase(courseId)) {
                                    c.getCourseTeacher().rateStudents(c.getCourseId(), studentId, grade);
                                    removeLineFromFile("src/models/students.txt", studentId); // remove previous data
                                    for (Student s : Faculty.getStudents()) {
                                        if (s.getId().equals(studentId)) {
                                            // write the updated data to the file
                                            writeData(s.toString(), "src/models/students.txt");
                                        }
                                    }
                                    break;
                                }
                            }
                        }
                        break;
                        case 7: {
                            out.println("For what course is this assignment? (enter course id)");
                            Scanner scanner3 = new Scanner(in);
                            String courseId = scanner3.nextLine();

                            boolean isYourCourse = isThisYourCourse(courseId, teacherId,
                                    "You don't have this course in your course list!");

                            if (!isYourCourse)
                                break;

                            out.println("What's the assignment's name?");
                            Scanner scanner4 = new Scanner(in);

                            String assignmentName = scanner4.nextLine();

                            out.println("What's the new deadline? (number of days left until deadline)");
                            Scanner scanner5 = new Scanner(in);
                            int newDeadline = scanner5.nextInt();

                            for (Course c : Faculty.getCourses()) {
                                if (c.getCourseTeacher().getId().equals(teacherId) && c.getCourseId().equalsIgnoreCase(courseId)) {
                                    c.getCourseTeacher().changeAssignmentDeadline(assignmentName, newDeadline);
                                    Assignment assignment = new Assignment(assignmentName, newDeadline, true, courseId);
                                    removeLineFromFile("src/models/assignments.txt", courseId, assignmentName);
                                    writeData(assignment.toString(), "src/models/assignments.txt");
                                    break;
                                }
                            }
                        }
                        break;
                    }
                }
                break; // we only want to process this teacher's requests
        }

            case 2: {
                while (userInput != 11) {
                    showAdminMenu();
                    userInput = scanner.nextInt();
                    switch (userInput) {
                        case 1: { // Here the admin can define a new teacher and save the data in a text file using toString method in Teacher.java:
                            out.println("Great! What is the name of this teacher?");
                            Scanner s = new Scanner(in);
                            String teacherName = s.nextLine();
                            out.println("And what is the id?");
                            String teacherId = s.nextLine();
                            out.println("What is the count of courses that this teacher presents?");
                            userInput = s.nextInt();

                            Teacher teacher = new Teacher(teacherName, teacherId, userInput);
                            Course course;

                            String courseName;
                            int countOfUnits;
                            String examDate;
                            String courseId;

                            for (int i = 1; i <= userInput; i++) {
                                out.println("What's the #" + i + " course name?");
                                Scanner scanner1 = new Scanner(in);
                                courseName = scanner1.nextLine();
                                out.println("What's the count of units?");
                                Scanner scanner2 = new Scanner(in);
                                countOfUnits = scanner2.nextInt();
                                out.println("What's the exam date of this course?");
                                Scanner scanner3 = new Scanner(in);
                                examDate = scanner3.nextLine();
                                out.println("What is the course ID?");
                                Scanner scanner4 = new Scanner(in);
                                courseId = scanner4.nextLine();

                                course = new Course(courseName, teacher,
                                        countOfUnits, examDate, Faculty.getSemester(), true, courseId);

                                writeData(course.toString(), "src/models/courses.txt");
                            }

                            writeData(teacher.toString(), "src/models/teachers.txt");
                        }
                        break;
                        case 2: {
                            File file = new File("src/models/courses.txt");

                            if (file.length() == 0) {
                                out.println("Oops! there isn't any defined course, first define a course so you can \n" +
                                        "add a student to that course.");
                                out.println("Your can define a course now or come back later!");
                                out.println("write 'OK' to define it now");
                                Scanner sc = new Scanner(in);
                                String adminCreatesCourse = sc.nextLine();
                                if (adminCreatesCourse.equalsIgnoreCase("ok")) {
                                    out.println("Great! what's the course name?");
                                    Scanner scanner1 = new Scanner(in);
                                    String courseName = scanner1.nextLine();

                                    out.println("What's the count of units?");
                                    userInput = scanner1.nextInt();

                                    out.println("When is the exam data? (write it like: 2024.1.12) (Y.M.D).");
                                    Scanner scanner2 = new Scanner(in);
                                    String courseExamDate = scanner2.nextLine();

                                    out.println("What is the id of this course's teacher?");
                                    Scanner scanner3 = new Scanner(in);
                                    String teacherId = scanner3.nextLine();

                                    out.println("What is the course ID? (a 8 digit number)");
                                    Scanner scanner4 = new Scanner(in);
                                    String courseId = scanner4.nextLine();

                                    Course course;
                                    for (Teacher t : Faculty.getTeachers()) {
                                        if (t.getId().equals(teacherId)) {
                                            course = new Course(courseName, t, userInput, courseExamDate, Faculty.getSemester(), true, courseId);
                                            t.addCourseToThisTeacher(course);
                                            writeData(course.toString(), "src/models/courses.txt");
                                            break;
                                        }
                                    }
                                    out.println("Course has been successfully created!");
                                } else {
                                    out.println("That's all right!\n See you later Admin!");
                                }

                            } else {
                                out.println("What is your target course ID?");
                                Scanner scanner1 = new Scanner(in);
                                String courseId = scanner1.nextLine();
//                                out.println("What's the student name?");
                                String studentName = "";
                                out.println("What's the student ID?");
                                Scanner scanner2 = new Scanner(in);
                                String studentId = scanner2.nextLine();
                                // we should check if the student is already in student.txt
                                int isAlreadyWritten = 0;
                                for (Student student: Faculty.getStudents()) {
                                    if (student.getId().equals(studentId)) {
                                        studentName = student.getName();
                                    }
                                }
                                Student student = new Student(studentName, studentId, "@" + studentId);
                                for (Student s : Faculty.getStudents()) {
                                    if (s.getId().equals(studentId)) { // student is already in file, so we want to overwrite it
                                        removeLineFromFile("src/models/students.txt", studentId); // remove the previous data
                                        for (Course c : Faculty.getCourses()) {
                                            if (c.getCourseId().equals(courseId)) {
                                                isAlreadyWritten = 1; // we found the target
                                                s.addCourseAndUnit(c);
                                                writeData(s.toString() + "/0.0", "src/models/students.txt"); // write the updated data to file
                                                out.println("Done!");
                                                break;
                                            }
                                        }
                                        break;
                                    }
                                }

                                if (isAlreadyWritten == 0) { // If this is a new student, we use the new object (student) and add
                                    // it to course and also the text file
                                    for (Course c : Faculty.getCourses()) {
                                        if (c.getCourseId().equals(courseId)) {
                                            c.addStudent(student);
                                            writeData(student.toString(), "src/models/students.txt"); // save the student to students.txt
                                            out.println("Done!");
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        break;
                        case 3: {
                            Scanner scanner1 = new Scanner(in);
                            out.println("What's the student's id?");
                            String studentId = scanner1.nextLine();
//
//                            out.println("What's the student's password?");
//                            String studentPassword = scanner1.nextLine();


                            out.println("What's the course id?");
                            Scanner scanner2 = new Scanner(in);
                            String courseId = scanner2.nextLine();
                            for (Course c : Faculty.getCourses()) {
                                if (c.getCourseId().equals(courseId)) {
                                    for (Student s : c.getStudentList()) {
                                        if (s.getId().equals(studentId)) {
                                            out.println(s.getCourses().size() + "-----------");
                                            c.eliminateStudent(s);
                                            out.println(s.getCourses().size()+ "-----------");
                                            removeLineFromFile("src/models/students.txt", studentId); // delete the old data
                                            writeData(s.toString(), "src/models/students.txt"); // write the updated data
                                            out.println("Done eliminating student!");
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        break;
                        case 4: {
                            out.println("What's the id of the course you want to delete?");
                            Scanner scanner1 = new Scanner(in);
                            String courseId = scanner1.nextLine();
                            for (Course c : Faculty.getCourses()) {
                                if (c.getCourseId().equals(courseId)) {
                                    for (Teacher t: Faculty.getTeachers()) {
                                        if (t.getPresentedCourses().contains(c)) {
                                            t.removeCourseFromThisTeacher(c);
                                            removeLineFromFile("src/models/teachers.txt", t.getId());
                                            writeData(t.toString(), "src/models/teachers.txt");
                                        }
                                    }
                                    Faculty.getCourses().remove(c);
                                    removeLineFromFile("src/models/courses.txt", courseId);
                                    break;
                                }
                            }
                        }
                        break;
                        case 5: {
                            out.println("For what course are you defining this assignment? (write only course id)");
                            Scanner scanner1 = new Scanner(in);
                            String courseId = scanner1.nextLine();
                            out.println("What would you call this assignment?");
                            Scanner scanner2 = new Scanner(in);
                            String assignmentName = scanner2.nextLine();
                            out.println("And how many days left until the deadline?");
                            Scanner scanner3 = new Scanner(in);
                            int assignmentDeadline = scanner3.nextInt();
                            for (Course c : Faculty.getCourses()) {
                                if (c.getCourseId().equals(courseId)) {
                                    c.getCourseTeacher().defineNewAssignment(c.getCourseId(), assignmentName, true, assignmentDeadline);
                                    writeData(c.getActiveProjects().getLast().toString(), "src/models/assignments.txt");
                                    break;
                                }
                            }
                        }
                        break;
                        case 6: { // deleteAnAssignment method is in Teacher.java, so we should somehow reach out to the teacher and invoke this method:
                            out.println("Ok! for what course was this assignment defined? (enter course id)");
                            Scanner scanner1 = new Scanner(in);
                            String courseId = scanner1.nextLine();
                            out.println("What's the assignment title? (it's name)");
                            Scanner scanner2 = new Scanner(in);
                            String assignmentName = scanner2.nextLine();
                            for (Course c : Faculty.getCourses()) {
                                if (c.getCourseId().equals(courseId)) {
                                    c.getCourseTeacher().deleteAnAssignment(c.getCourseId(), assignmentName);
                                    break;
                                }
                            }
                            removeLineFromFile("src/models/assignments.txt", assignmentName, courseId); // assignment is removed from file
                            out.println("Your desired assignment has been successfully deleted.");
                        }
                        break;
                        case 7: {
                            out.println("Ok! for what course was this assignment defined? (enter course id)");
                            Scanner scanner1 = new Scanner(in);
                            String courseId = scanner1.nextLine();
                            out.println("What's the assignment title? (it's name)");
                            Scanner scanner2 = new Scanner(in);
                            String assignmentName = scanner2.nextLine();
                            for (Assignment a : Faculty.getAssignments()) {
                                if (a.getName().equals(assignmentName)) {
                                    if (!a.isStatus())
                                        out.println("You cannot change the deadline of a unactivated assignment.");
                                    else {
                                        out.println("How much do you wanna give time to students:)? (how many days)");
                                        Scanner scanner3 = new Scanner(in);
                                        int newDeadline = scanner3.nextInt();
                                        a.setDeadline(newDeadline);
                                        removeLineFromFile("src/models/assignments.txt", assignmentName, courseId);
                                        writeData(a.toString(), "src/models/assignments.txt");
                                    }
                                    break;
                                }
                            }
                        }
                        break;
                        case 8: { // Just like case 6, we need to reach out to the teacher and invoke the rateStudents method
                            out.println("What's the student's ID?");
                            Scanner scanner1 = new Scanner(in);
                            String studentId = scanner1.nextLine();
                            out.println("In what course are you intended to rate the student? (write only course id)");
                            Scanner scanner2 = new Scanner(in);
                            String courseId = scanner2.nextLine();
                            out.println("What's the grade?");
                            Scanner scanner3 = new Scanner(in);
                            double grade = scanner3.nextDouble();

                            for (Course c : Faculty.getCourses()) {
                                if (c.getCourseId().equalsIgnoreCase(courseId)) {
                                    c.getCourseTeacher().rateStudents(c.getCourseId(), studentId, grade);
                                    removeLineFromFile("src/models/students.txt", studentId); // remove previous data
                                    for (Student s : Faculty.getStudents()) {
                                        if (s.getId().equals(studentId)) {
                                            // write the updated data to the file
                                            writeData(s.toString(), "src/models/students.txt");
                                        }
                                    }
                                    break;
                                }
                            }
                            out.println("Done rating the student!");
                        }
                        break;
                        case 9: {
                            out.println("What's your student's ID?");
                            Scanner scanner1 = new Scanner(in);
                            String studentId = scanner1.nextLine();

                            for (Student s : Faculty.getStudents()) {
                                if (s.getId().equals(studentId)) {
                                    s.printStudentCourses();
                                    break;
                                }
                            }
                        }
                        break;
                        case 10: {
                            out.println("What's the student's ID?");
                            Scanner scanner1 = new Scanner(in);
                            String studentId = scanner1.nextLine();

                            for (Student s : Faculty.getStudents()) {
                                if (s.getId().equals(studentId)) {
                                    out.print("All time average is: ");
                                    s.printStudentAllTimeAvg();
                                    out.print("This semester's average is: ");
                                    s.printRegisteredAvg();
                                    break;
                                }
                            }
                        }
                        break;
                    }
                }

            } break;
            default: {
                out.println("You should either be a teacher or an admin!");
            }
        }
    }
}



