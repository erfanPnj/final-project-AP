import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {
    static void clearScreen() {
        System.out.print("\033[H\033[2J");
        System.out.flush();
    } // which does not work in IDE's terminal!

    // we need to delete data from .txt files after performing a removal activity:
    static void removeLineFromFile(String filePath, String... clue) throws IOException {
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
    }

    static void showTeacherMenu() { //todo: It should go to view
        System.out.println("1. Show my courses.");
        System.out.println("2. Add student to a course.");
        System.out.println("3. Remove student from a course.");
        System.out.println("4. Define new assignment.");
        System.out.println("5. Delete an existing assignment.");
        System.out.println("6. Rate a student in a course.");
        System.out.println("7. Change the deadline of an assignment.");
    }

    static void showAdminMenu() {//todo: It should go to view
        System.out.println("1. Add a new teacher.");
        System.out.println("2. Add student to a course.");
        System.out.println("3. Remove student from a course.");
        System.out.println("4. Delete a course.");
        System.out.println("5. Define new assignment.");
        System.out.println("6. Delete an existing assignment.");
        System.out.println("7. Change the deadline of an assignment.");
        System.out.println("8. Rate a student.");
        System.out.println("9. Show an student's courses list.");
        System.out.println("10. Show an student's average.");
    }

    static void writeData(String data, String filePath) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
            writer.write(data);
            writer.newLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static void loadTeacherData(String filePath, List<Teacher> list) throws FileNotFoundException {
        File file = new File(filePath);
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String data = scanner.nextLine();
            String[] parts;
            parts = data.split("-");
            Teacher teacher = new Teacher(parts[0], parts[1], Integer.parseInt(parts[2]));
            list.add(teacher);
        }
    }

    static void loadCourseData(String filePath, List<Course> list) throws IOException {
        // we need teachers data first, so we load it right here:
        loadTeacherData("src/teachers.txt", Faculty.getTeachers());
        File file = new File(filePath);
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String data = scanner.nextLine();
            String[] parts;
            parts = data.split("-");

            for (Teacher t : Faculty.getTeachers()) {
                if (t.getName().equals(parts[1])) {
                    if (parts[4].equals("true")) {
                        list.add(new Course(parts[0], t, Integer.parseInt(parts[2]), parts[3], Faculty.getSemester(), true));
                        // update teachers data after adding course
                        removeLineFromFile("src/teachers.txt", t.getId());
                        writeData(t.toString(), "src/teachers.txt");
                    } else {
                        list.add(new Course(parts[0], t, Integer.parseInt(parts[2]), parts[3], Faculty.getSemester(), false));
                        removeLineFromFile("src/teachers.txt", t.getId());
                        writeData(t.toString(), "src/teachers.txt");
                    }
                    break;
                }
            }
        }
    }

    static void loadStudentData(String filePath, List<Student> list) throws IOException {
        // we need courses data first, so we load it here and by doing this, we have also loaded teachers data!
        loadCourseData("src/courses.txt", Faculty.getCourses());
        File file = new File(filePath);
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String data = scanner.nextLine();
            String[] parts;
            parts = data.split("-");
            Student student = new Student(parts[0], parts[1]);
            if (parts.length >= 3) { // in case the student is not attended to any course, like Erfan-2222 (there is no parts[2])
                for (int i = 2; i < parts.length; i++) {
                    for (Course c : Faculty.getCourses()) {
                        if (c.getCourseName().equals(parts[i]))
                            student.addCourseAndUnit(c);
                    }
                }
            }
            list.add(student);
        }
    }

    static void loadAssignmentData(String filePath, List<Assignment> list) throws FileNotFoundException {
        File file = new File(filePath);
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String data = scanner.nextLine();
            String[] parts;
            parts = data.split("-");
            if (parts[2].equals("true"))
                list.add(new Assignment(parts[0], Integer.parseInt(parts[1]), true, parts[3]));
            else
                list.add(new Assignment(parts[0], Integer.parseInt(parts[1]), false, parts[3]));
        }
    }

    public static void main(String[] args) throws IOException {
        new Faculty("computerEngineering", 2);

        // After each launch of the program, we need to load the data from text files:
        loadStudentData("src/students.txt", Faculty.getStudents()); // also loads teachers data and courses data
        loadAssignmentData("src/assignments.txt", Faculty.getAssignments());

        //##################################################################################
        System.out.println(Faculty.getTeachers().toString());
        for (Teacher t : Faculty.getTeachers()) {
            System.out.println(t.getId());
        }
        System.out.println(Faculty.getCourses().toString());
        System.out.println(Faculty.getStudents().toString());
        for (Student s : Faculty.getStudents()) {
            System.out.println(s.getCourses().toString());
        }
        //##################################################################################

        System.out.println("Welcome to DaneshjooYar!\nPlease choose your roll:\n1. Teacher\n2. Admin");
        Scanner scanner = new Scanner(System.in);

        int userInput = scanner.nextInt();

        String name, id;

        System.out.println(Faculty.getAssignments().toString());

        switch (userInput) {
            case 1: {
                System.out.println("Please enter your name:");
                Scanner scanner1 = new Scanner(System.in);
                String teacherName = scanner1.nextLine();
                int isTeacherRegistered = 0;
                for (Teacher t : Faculty.getTeachers()) {
                    if (t.getName().equalsIgnoreCase(teacherName))
                        isTeacherRegistered++;
                }
                if (isTeacherRegistered == 0) {
                    System.out.println("You are not registered in this faculty, please contact the admin for registration.");
                    break;
                }
                System.out.println("Please enter your teacher ID:");
                Scanner scanner2 = new Scanner(System.in);
                String teacherId = scanner2.nextLine();
                for (Teacher t : Faculty.getTeachers()) {
                    if (t.getName().equals(teacherName) && t.getId().equals(teacherId)) {
                        System.out.println("Welcome!\n\n");
                        showTeacherMenu();
                        userInput = scanner.nextInt();
                        switch (userInput) {
                            case 1: {
                                for (Course c : Faculty.getCourses()) {
                                    if (c.getCourseTeacher().getId().equals(teacherId)) {
                                        System.out.println(c.getCourseName());
                                    }
                                }
                            }
                            break;
                            case 2: {
                                System.out.println("What's the student's name?");
                                Scanner scanner3 = new Scanner(System.in);
                                String studentName = scanner3.nextLine();
                                System.out.println("What's the student's ID?");
                                Scanner scanner4 = new Scanner(System.in);
                                String studentId = scanner4.nextLine();
                                System.out.println("What's the target course?");
                                Scanner scanner5 = new Scanner(System.in);
                                String courseName = scanner5.nextLine();

                                int isAlreadyWritten = 0;
                                Student student = new Student(studentName, studentId);
                                for (Student s : Faculty.getStudents()) {
                                    if (s.getId().equals(studentId)) { // student is already in file, so we want to overwrite it
                                        removeLineFromFile("src/students.txt", studentId); // remove the previous data
                                        for (Course c : Faculty.getCourses()) {
                                            if (c.getCourseName().equals(courseName)) {
                                                isAlreadyWritten = 1; // we found the target
                                                s.addCourseAndUnit(c);
                                                writeData(s.toString(), "src/students.txt"); // write the updated data to file
                                                System.out.println("Done!");
                                                break;
                                            }
                                        }
                                        break;
                                    }
                                }

                                if (isAlreadyWritten == 0) { // If this is a new student, we use the new object (student) and add
                                    // it to course and also the text file
                                    for (Course c : Faculty.getCourses()) {
                                        if (c.getCourseName().equals(courseName)) {
                                            c.addStudent(student);
                                            writeData(student.toString(), "src/students.txt"); // save the student to students.txt
                                            System.out.println("Done!");
                                            break;
                                        }
                                    }
                                }
                            }
                            break;
                            case 3: {
                                System.out.println("What's the student name?");
                                Scanner scanner3 = new Scanner(System.in);
                                String studentName = scanner3.nextLine();
                                System.out.println("What's the student's ID?");
                                Scanner scanner4 = new Scanner(System.in);
                                String studentId = scanner4.nextLine();
                                System.out.println("What's the course name?");
                                Scanner scanner5 = new Scanner(System.in);
                                String courseName = scanner5.nextLine();

                                for (Course c : Faculty.getCourses()) {
                                    if (c.getCourseName().equals(courseName) && c.getCourseTeacher().getId().equals(teacherId)) {
                                        removeLineFromFile("src/students.txt", studentId);
                                        for (Student s : Faculty.getStudents()) {
                                            if (s.getId().equals(studentId)) {
                                                c.eliminateStudent(s);
                                                writeData(s.toString(), "src/students.txt");
                                            }
                                        }
                                        break;
                                    }
                                }
                            }
                            break;
                            case 4: {
                                System.out.println("Great! for which course do you wanna define a new assignment?");
                                Scanner scanner3 = new Scanner(System.in);
                                String courseName = scanner3.nextLine();
                                System.out.println("What would you call your newly defined assignment?");
                                Scanner scanner4 = new Scanner(System.in);
                                String assignmentName = scanner4.nextLine();
                                System.out.println("How many days have you considered until deadline?");
                                Scanner scanner5 = new Scanner(System.in);
                                int deadline = scanner5.nextInt();

                                for (Course c : Faculty.getCourses()) {
                                    if (c.getCourseTeacher().getId().equals(teacherId) && c.getCourseName().equalsIgnoreCase(courseName)) {
                                        Assignment assignment = new Assignment(assignmentName, deadline, true, courseName);
                                        writeData(assignment.toString(), "src/assignments.txt");
                                        c.getCourseTeacher().defineNewAssignment(c.getCourseName(), assignmentName, true, deadline);
                                        break;
                                    }
                                }
                            }
                            break;
                            case 5: {
                                System.out.println("From what course do you want to delete an assignment?");
                                Scanner scanner3 = new Scanner(System.in);
                                String courseName = scanner3.nextLine();
                                System.out.println("Ok! What is the name of the assignment you want to delete?");
                                Scanner scanner4 = new Scanner(System.in);
                                String assignmentName = scanner4.nextLine();

                                for (Course c : Faculty.getCourses()) {
                                    if (c.getCourseTeacher().getId().equals(teacherId) && c.getCourseName().equalsIgnoreCase(courseName)) {
                                        removeLineFromFile("src/assignments.txt", assignmentName, courseName);
                                        c.getCourseTeacher().deleteAnAssignment(c.getCourseName(), assignmentName);
                                        break;
                                    }
                                }
                            }
                            break;
                            case 6: {
                                System.out.println("What's the student's ID?");
                                Scanner scanner3 = new Scanner(System.in);
                                String studentId = scanner3.nextLine();
                                System.out.println("In what course do you want to rate this student?");
                                Scanner scanner4 = new Scanner(System.in);
                                String courseName = scanner4.nextLine();
                                System.out.println("What's the grade?");
                                Scanner scanner5 = new Scanner(System.in);
                                double grade = scanner5.nextDouble();

                                for (Course c : Faculty.getCourses()) {
                                    if (c.getCourseTeacher().getId().equals(teacherId) && c.getCourseName().equalsIgnoreCase(courseName)) {
                                        c.getCourseTeacher().rateStudents(c.getCourseName(), studentId, grade);
                                        break;
                                    }
                                }
                            }
                            break;
                            case 7: {
                                System.out.println("For what course is this assignment?");
                                Scanner scanner3 = new Scanner(System.in);
                                String courseName = scanner3.nextLine();
                                System.out.println("What's the assignment's name?");
                                Scanner scanner4 = new Scanner(System.in);
                                String assignmentName = scanner4.nextLine();
                                System.out.println("What's the new deadline? (number of days left until deadline)");
                                Scanner scanner5 = new Scanner(System.in);
                                int newDeadline = scanner5.nextInt();

                                for (Course c : Faculty.getCourses()) {
                                    if (c.getCourseTeacher().getId().equals(teacherId) && c.getCourseName().equalsIgnoreCase(courseName)) {
                                        c.getCourseTeacher().changeAssignmentDeadline(assignmentName, newDeadline);
                                        Assignment assignment = new Assignment(assignmentName, newDeadline, true, courseName);
                                        removeLineFromFile("src/assignments.txt", courseName, assignmentName);
                                        writeData(assignment.toString(), "src/assignments.txt");
                                        break;
                                    }
                                }
                            }
                            break;
                        }
                    }
//                    else if(!t.getId().equals(teacherId)) {
//                        System.out.println("Wrong name/Id!");
////                        continue;
//                    }
                    else {
                        continue;
                    }
                    break; // we only want to process this teacher's requests
                }
            }
            break;
            case 2: {
                showAdminMenu();
                userInput = scanner.nextInt();
                switch (userInput) {
                    case 1: { // Here the admin can define a new teacher and save the data in a text file using toString method in Teacher.java:
                        System.out.println("Great! What is the name of this teacher?");
                        Scanner s = new Scanner(System.in);
                        name = s.nextLine();
                        System.out.println("And what is the id?");
                        id = s.nextLine();
                        System.out.println("And in the end, what is the count of courses that this teacher presents?");
                        userInput = s.nextInt();

                        writeData(new Teacher(name, id, userInput).toString(), "src/teachers.txt");
                    }
                    break;
                    case 2: {
                        File file = new File("src/courses.txt");

                        if (file.length() == 0) {
                            System.out.println("Oops! there isn't any defined course, first define a course so you can \n" +
                                    "add a student to that course.");
                            System.out.println("Your can define a course now or come back later!");
                            System.out.println("write 'OK' to define it now");
                            Scanner sc = new Scanner(System.in);
                            String adminCreatesCourse = sc.nextLine();
                            if (adminCreatesCourse.equalsIgnoreCase("ok")) {
                                System.out.println("Great! what's the course name?");
                                Scanner scanner1 = new Scanner(System.in);
                                String courseName = scanner1.nextLine();

                                System.out.println("What's the count of units?");
                                userInput = scanner1.nextInt();

                                System.out.println("When is the exam data? (write it like: 2024.1.12) (Y.M.D).");
                                Scanner scanner2 = new Scanner(System.in);
                                String courseExamDate = scanner2.nextLine();

                                System.out.println("What is the name of this course's teacher?");
                                Scanner scanner3 = new Scanner(System.in);
                                String teacherName = scanner3.nextLine();
                                Course course;
                                for (Teacher t : Faculty.getTeachers()) {
                                    if (t.getName().equals(teacherName)) {
                                        course = new Course(courseName, t, userInput, courseExamDate, Faculty.getSemester(), true);
                                        t.addCourseToThisTeacher(course);
                                        writeData(course.toString(), "src/courses.txt");
                                        break;
                                    }
                                }
                                System.out.println("Course has been successfully created!");
                            } else {
                                System.out.println("That's all right!\n See you later Admin!");
                            }

                        } else {
                            System.out.println("What is your target course name?");
                            Scanner scanner1 = new Scanner(System.in);
                            String courseName = scanner1.nextLine();
                            System.out.println("What's the student name?");
                            String studentName = scanner1.nextLine();
                            System.out.println("What's the student ID?");
                            Scanner scanner2 = new Scanner(System.in);
                            String studentId = scanner2.nextLine();
                            // we should check if the student is already in student.txt
                            int isAlreadyWritten = 0;
                            Student student = new Student(studentName, studentId);
                            for (Student s : Faculty.getStudents()) {
                                if (s.getId().equals(studentId)) { // student is already in file, so we want to overwrite it
                                    removeLineFromFile("src/students.txt", studentId); // remove the previous data
                                    for (Course c : Faculty.getCourses()) {
                                        if (c.getCourseName().equals(courseName)) {
                                            isAlreadyWritten = 1; // we found the target
                                            s.addCourseAndUnit(c);
                                            writeData(s.toString(), "src/students.txt"); // write the updated data to file
                                            System.out.println("Done!");
                                            break;
                                        }
                                    }
                                    break;
                                }
                            }

                            if (isAlreadyWritten == 0) { // If this is a new student, we use the new object (student) and add
                                // it to course and also the text file
                                for (Course c : Faculty.getCourses()) {
                                    if (c.getCourseName().equals(courseName)) {
                                        c.addStudent(student);
                                        writeData(student.toString(), "src/students.txt"); // save the student to students.txt
                                        System.out.println("Done!");
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    break;
                    case 3: {
                        System.out.println("What's the student's name?");
                        Scanner scanner1 = new Scanner(System.in);
                        String studentName = scanner1.nextLine();
                        System.out.println("What's the student's id?");
                        String studentId = scanner1.nextLine();

                        System.out.println("What's the course name?");
                        Scanner scanner2 = new Scanner(System.in);
                        String courseName = scanner2.nextLine();
                        for (Course c : Faculty.getCourses()) {
                            if (c.getCourseName().equals(courseName)) {
                                for (Student s : c.getStudentList()) {
                                    if (s.equals(new Student(studentName, studentId))) {
                                        c.eliminateStudent(s);
                                        removeLineFromFile("src/students.txt", studentId); // delete the old data
                                        writeData(s.toString(), "src/students.txt"); // write the updated data
                                        System.out.println("Done eliminating student!");
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    break;
                    case 4: {
                        System.out.println("What's the name of the course you want to delete?");
                        Scanner scanner1 = new Scanner(System.in);
                        String courseName = scanner1.nextLine();
                        for (Course c : Faculty.getCourses()) {
                            if (c.getCourseName().equals(courseName)) {
                                Faculty.getCourses().remove(c);
                                removeLineFromFile("src/courses.txt", courseName);
                                break;
                            }
                        }
                    }
                    break;
                    case 5: {
                        System.out.println("For what course are you defining this assignment? (write only course name)");
                        Scanner scanner1 = new Scanner(System.in);
                        String courseName = scanner1.nextLine();
                        System.out.println("What would you call this assignment?");
                        Scanner scanner2 = new Scanner(System.in);
                        String assignmentName = scanner2.nextLine();
                        System.out.println("And how many days left until the deadline?");
                        Scanner scanner3 = new Scanner(System.in);
                        int assignmentDeadline = scanner3.nextInt();
                        for (Course c : Faculty.getCourses()) {
                            if (c.getCourseName().equals(courseName)) {
                                c.getCourseTeacher().defineNewAssignment(c.getCourseName(), assignmentName, true, assignmentDeadline);
                                writeData(c.getActiveProjects().getLast().toString(), "src/assignments.txt");
                                break;
                            }
                        }
                    }
                    break;
                    case 6: { // deleteAnAssignment method is in Teacher.java, so we should somehow reach out to the teacher and invoke this method:
                        System.out.println("Ok! for what course was this assignment defined?");
                        Scanner scanner1 = new Scanner(System.in);
                        String courseName = scanner1.nextLine();
                        System.out.println("What's the assignment title? (it's name)");
                        Scanner scanner2 = new Scanner(System.in);
                        String assignmentName = scanner2.nextLine();
                        for (Course c : Faculty.getCourses()) {
                            if (c.getCourseName().equals(courseName)) {
                                c.getCourseTeacher().deleteAnAssignment(c.getCourseName(), assignmentName);
                                break;
                            }
                        }
                        removeLineFromFile("src/assignments.txt", assignmentName); // assignment is removed from file
                        System.out.println("Your desired assignment has been successfully deleted.");
                    }
                    break;
                    case 7: {
                        System.out.println("Ok! for what course was this assignment defined?");
                        Scanner scanner1 = new Scanner(System.in);
                        String courseName = scanner1.nextLine();
                        System.out.println("What's the assignment title? (it's name)");
                        Scanner scanner2 = new Scanner(System.in);
                        String assignmentName = scanner2.nextLine();
                        for (Assignment a : Faculty.getAssignments()) {
                            if (a.getName().equals(assignmentName)) {
                                if (!a.isStatus())
                                    System.out.println("You cannot change the deadline of a unactivated assignment.");
                                else {
                                    System.out.println("How much do you wanna give time to students:)? (how many days)");
                                    Scanner scanner3 = new Scanner(System.in);
                                    int newDeadline = scanner3.nextInt();
                                    a.setDeadline(newDeadline);
                                    removeLineFromFile("src/assignments.txt", assignmentName, courseName);
                                    writeData(a.toString(), "src/assignments.txt");
                                }
                                break;
                            }
                        }
                    }
                    break;
                    //todo: RATING STUDENTS ISN'T SAVED, BECAUSE STUDENT.toString() IGNORES GRADES. FIX THIS.
                    case 8: { // Just like case 6, we need to reach out to the teacher and invoke the rateStudents method
                        System.out.println("What's the student's ID?");
                        Scanner scanner1 = new Scanner(System.in);
                        String studentId = scanner1.nextLine();
                        System.out.println("In what course are you intended to rate the student? (write only course name)");
                        Scanner scanner2 = new Scanner(System.in);
                        String courseName = scanner2.nextLine();
                        System.out.println("What's the grade?");
                        Scanner scanner3 = new Scanner(System.in);
                        double grade = scanner3.nextDouble();

                        for (Course c : Faculty.getCourses()) {
                            if (c.getCourseName().equals(courseName)) {
                                c.getCourseTeacher().rateStudents(courseName, studentId, grade);
                            }
                        }
                        System.out.println("Done rating the student!");
                    }
                    break;
                    case 9: {
                        System.out.println("What's your student's ID?");
                        Scanner scanner1 = new Scanner(System.in);
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
                        System.out.println("What's the student's ID?");
                        Scanner scanner1 = new Scanner(System.in);
                        String studentId = scanner1.nextLine();

                        for (Student s : Faculty.getStudents()) {
                            if (s.getId().equals(studentId)) {
                                System.out.print("All time average is: ");
                                s.printStudentAllTimeAvg();
                                System.out.print("This semester's average is: ");
                                s.printRegisteredAvg();
                                break;
                            }
                        }
                    }
                    break;
                }
            }
        }
    }
}



