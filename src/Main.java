import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {
    static void clearScreen () {
        System.out.print("\033[H\033[2J");
        System.out.flush();
    }

    public static <T> void saveData(List<T> list, String fileName) {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(fileName))) {
            oos.writeObject(list);
        } catch (IOException e) {
            System.out.println("An error occurred!");
        }
    }

    public static <T> List<T> loadData(String fileName, Class<T> type) {
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(fileName))) {
            List<?> rawList = (List<?>) ois.readObject();
            List<T> typedList = new ArrayList<>();
            for (Object obj : rawList) {
                if (type.isInstance(obj)) {
                    typedList.add(type.cast(obj));
                } else {
                    throw new ClassNotFoundException("Object of type " + obj.getClass().getName() +
                            " found in file does not match expected type " + type.getName());
                }
            }
            return typedList;
        } catch (IOException | ClassNotFoundException e) {
            System.out.println("An error occurred: " + e.getMessage());
            return new ArrayList<>();
        }
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
        System.out.println("4. Define new assignment.");
        System.out.println("5. Delete an existing assignment.");
        System.out.println("6. Delete a course.");
        System.out.println("7. Change the deadline of an assignment.");
    }

    public static void main(String[] args) {
        new Faculty("computerEngineering", 2);
        List<Student> students = new ArrayList<>();
        List<Teacher> teachers = new ArrayList<>();
        List<Course> courses = new ArrayList<>();
        List<Assignment> assignments = new ArrayList<>();

        System.out.println("Welcome to DaneshjooYar!\nPlease choose your roll:\n1. Teacher\n2. Admin");
        Scanner scanner = new Scanner(System.in);

        int userInput = scanner.nextInt();

        String name, id, userAnswer;

        clearScreen();

        switch (userInput) {
            case 1:
                showTeacherMenu();
            case 2:{
                showAdminMenu();
                userInput = scanner.nextInt();
                clearScreen();
                switch (userInput) {
                    case 1:{
                        System.out.println("Great! What is the name of this teacher?");
                        Scanner s = new Scanner(System.in);
                        name = s.nextLine();
                        System.out.println("And what is the id?");
                        id = s.nextLine();
                        System.out.println("And in the end, what is the count of courses that this teacher presents?");
                        userInput = s.nextInt();

                        new Teacher(name, id, userInput);
                        String fileName = "src/teachers.txt";
                        teachers.addAll(Faculty.getTeachers());
                        saveData(teachers, fileName);
                        break;
                    }
                    case 2:{
                        File file = new File("courses.txt");
                        if (file.length() == 0) {
                            System.out.println("Oops! there isn't any defined course, first define a course so you can \n" +
                                    "add a student to that course.");
                        } else {
                            System.out.println("What is your target course name?");
                            userAnswer = scanner.nextLine();
                            for (Course c : loadData("courses.txt", Course.class)) {
                                if (c.getCourseName().equals(userAnswer)) {
                                    System.out.println("What is the student's name?");
                                    name = scanner.nextLine();
                                    System.out.println("Great! what is the student id?");
                                    id = scanner.nextLine();
                                    new Student(name, id);
                                    String fileName = "src/students.txt";
                                    students.addAll(Faculty.getStudents());
                                    saveData(students, fileName);
                                    break; // after finding and processing the target course, we break the loop
                                }
                            }
                        } break;
                    }



                }
            }
        }

    }
}
