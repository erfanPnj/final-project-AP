import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {
    static void clearScreen () {
        System.out.print("\033[H\033[2J");
        System.out.flush();
    } // which does not work in IDE's terminal!

    // we need to delete data from .txt files after performing a removal activity:
    static void removeLineFromFile (String filePath, String clue) throws IOException{
        File file = new File(filePath);
        Scanner scanner = new Scanner(file);
        String lineToRemove = "";

        while (scanner.hasNextLine()) {
            String previouslyReadLine = scanner.nextLine();
            if (previouslyReadLine.contains(clue)) {
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

    static void showTeacherMenu() {
        System.out.println("1. Show my courses.");
        System.out.println("2. Add student to a course.");
        System.out.println("3. Remove student from a course.");
        System.out.println("4. Define new assignment.");
        System.out.println("5. Delete an existing assignment.");
        System.out.println("6. Rate a student in a course.");
        System.out.println("7. Change the deadline of an assignment.");
    }

    static void showAdminMenu() {
        System.out.println("1. Add a new teacher.");
        System.out.println("2. Add student to a course.");
        System.out.println("3. Remove student from a course.");
        System.out.println("4. Delete a course.");
        System.out.println("5. Define new assignment.");
        System.out.println("6. Delete an existing assignment.");
        System.out.println("7. Change the deadline of an assignment.");
    }

    static void writeData(String data, String filePath) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
            writer.write(data);
            writer.newLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static void loadTeacherData (String filePath, List<Teacher> list) throws FileNotFoundException {
        File file = new File(filePath);
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String data = scanner.nextLine();
            String[] parts;
            parts = data.split("-");
            list.add(new Teacher(parts[0], parts[1], Integer.parseInt(parts[2])));
        }
    }

    static void loadCourseData (String filePath, List<Course> list) throws FileNotFoundException{
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
                    } else {
                        list.add(new Course(parts[0], t, Integer.parseInt(parts[2]), parts[3], Faculty.getSemester(), false));
                    }
                    break;
                }
            }
        }
    }

    static void loadStudentData (String filePath, List<Student> list) throws FileNotFoundException{
        File file = new File(filePath);
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String data = scanner.nextLine();
            String[] parts;
            parts = data.split("-");
            list.add(new Student(parts[0], parts[1]));
        }
    }

    static void loadAssignmentData (String filePath, List<Assignment> list) throws FileNotFoundException{
        File file = new File(filePath);
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String data = scanner.nextLine();
            String[] parts;
            parts = data.split("-");
            if (parts[2].equals("true"))
                list.add(new Assignment(parts[0], Integer.parseInt(parts[1]), true));
            else
                list.add(new Assignment(parts[0], Integer.parseInt(parts[1]), false));
        }
    }

    public static void main(String[] args) throws IOException {
        new Faculty("computerEngineering", 2);

        System.out.println("Welcome to DaneshjooYar!\nPlease choose your roll:\n1. Teacher\n2. Admin");
        Scanner scanner = new Scanner(System.in);

        int userInput = scanner.nextInt();

        String name, id;

        clearScreen();
        loadTeacherData("src/teachers.txt", Faculty.getTeachers());
        loadCourseData("src/courses.txt", Faculty.getCourses());
        loadStudentData("src/students.txt", Faculty.getStudents());
        Faculty.getCourses().getFirst().addStudent(new Student("ali", "1234567"));


        switch (userInput) {
            case 1:
                showTeacherMenu();
            case 2:{
                showAdminMenu();
                userInput = scanner.nextInt();
                clearScreen();
                switch (userInput) {
                    case 1:{ // Here the admin can define a new teacher and save the data in a text file using toString method in Teacher.java:
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
                    case 2:{
                        File file = new File("src/courses.txt");

                        if (file.length() == 0) {
                            System.out.println("Oops! there isn't any defined course, first define a course so you can \n" +
                                    "add a student to that course.");
                            System.out.println("Your can create a course now or come back later!");
                            System.out.println("write 'OK' to create it now");
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

                                loadTeacherData("src/teachers.txt", Faculty.getTeachers());
//
                                for (Teacher t : Faculty.getTeachers()) {
                                    if (t.getName().equals(teacherName)) {
                                        writeData(new Course(courseName, t, userInput, courseExamDate, Faculty.getSemester(), true).toString(), "src/courses.txt");
                                        break;
                                    }
                                }
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
                            Student student = new Student(studentName, studentId);
                            writeData(student.toString(), "src/students.txt"); // save the student to students.txt

                            loadCourseData("src/courses.txt", Faculty.getCourses());

                            for (Course c : Faculty.getCourses()) {
                                if (c.getCourseName().equals(courseName)) {
                                    c.addStudent(student);
                                    System.out.println("Done!");
                                    break;
                                }
                            }
                        }
                        break;
                    }
                    case 3: {
                        System.out.println("What's the student's name?");
                        Scanner scanner1 = new Scanner(System.in);
                        String studentName = scanner1.nextLine();
                        System.out.println("What's the student's id?");
                        String studentId = scanner1.nextLine();
                        loadStudentData("src/students.txt", Faculty.getStudents());


                        System.out.println("What's the course name?");
                        Scanner scanner2 = new Scanner(System.in);
                        String courseName = scanner2.nextLine();
                        loadCourseData("src/courses.txt", Faculty.getCourses());

                        for (Course c : Faculty.getCourses()) {
                            if (c.getCourseName().equals(courseName)) {
                                for (Student s : c.getStudentList()) {
                                    if (s.equals(new Student(studentName, studentId))) {
                                        c.eliminateStudent(new Student(studentName, studentId));
                                        System.out.println("Done eliminating student!");
                                        break;
                                    }
                                }
                            }
                        }
                        break;
                    }
                    case 4: {
                        System.out.println("What's the name of the course you want to delete?");
                        Scanner scanner1 = new Scanner(System.in);
                        String courseName = scanner1.nextLine();
                        loadCourseData("src/courses.txt", Faculty.getCourses());

                        for (Course c : Faculty.getCourses()) {
                            if (c.getCourseName().equals(courseName)) {
                                Faculty.getCourses().remove(c);
                                removeLineFromFile("src/courses.txt", courseName);
                                break;
                            }
                        }
                    }
                    case 5:
                        System.out.println("For what course are you defining this assignment? (write only course name)");
                        Scanner scanner1 = new Scanner(System.in);
                        String courseName = scanner1.nextLine();
                        System.out.println("What would you call this assignment?");
                        Scanner scanner2 = new Scanner(System.in);
                        String assignmentName = scanner2.nextLine();
                        System.out.println("And how many days left until the deadline?");
                        Scanner scanner3 = new Scanner(System.in);
                        int assignmentDeadline = scanner3.nextInt();
                        loadCourseData("src/courses.txt", Faculty.getCourses()); // load courses from the file (our database)
                        for (Course c : Faculty.getCourses()) {
                            if (c.getCourseName().equals(courseName)) {
                                c.getCourseTeacher().defineNewAssignment(c, assignmentName, true, assignmentDeadline);
                                writeData(c.getActiveProjects().getLast().toString(), "src/assignments.txt");
                                break;
                            }
                        }

                }
            }
        }

    }
}
