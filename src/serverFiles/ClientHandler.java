package serverFiles;


import models.Course;
import models.Faculty;
import models.Main;
import models.Student;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

class ClientHandler extends Thread {
    Socket socket;
    DataOutputStream dos;
    DataInputStream dis;
    List<String> loggedInUsers= new ArrayList<>(); // it stores student id of logged in students

    public ClientHandler(Socket socket) throws IOException {
        this.socket = socket;
        dos = new DataOutputStream(socket.getOutputStream());
        dis = new DataInputStream(socket.getInputStream());
        System.out.println("connected to server");
    }

    // convert sever message to string
    public String listener() throws IOException {
        try{
            System.out.println("listener is activated");
            StringBuilder sb = new StringBuilder();
            int index = dis.read();
            while (index != 0) {
                sb.append((char) index);
                index = dis.read();
            }
            Scanner s = new Scanner(sb.toString());
            StringBuilder request = new StringBuilder();
            while (s.hasNextLine()) {
                request.append(s.nextLine());
            }
            System.out.println("listener2 -> read command successfully");
            return request.toString();}
        catch (IOException e) {
            System.out.println("error in listener : " + e);}
        return "Error!";
    }

    // send the response to server
    public void writer(String write) throws IOException {
        dos.writeBytes(write);
        dos.flush();
        dos.close();
        dis.close();
        socket.close();
        System.out.println(write);
        System.out.println("command finished and response sent to server");
    }

    @Override
    public void run() {
        super.run();
        String command;
        try {
            command = listener();
            System.out.println("command received: { " + command + " }");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        String[] split = command.split("~");

        switch (split[0]) {
            case "logIn": {    //GET: logInChecker~402243056~MN45o9
                // 2 -> both user ID & password is correct so allow signing in
                // 1 -> user ID is correct but password is incorrect
                // 0 -> user ID is incorrect
                // first we need to verify if there is a student with this student id
                int responseOfDatabase = 100;
                boolean isAMatchFound = false;
                String studentName = "";
                for (Student student : Faculty.getStudents()) {
                    if (student.getId().equals(split[1])) {
                        isAMatchFound = true;
                        studentName = student.getName();
                        if (student.getPassword().equals(split[2])) {
                            responseOfDatabase = 2;
                        } else {
                            responseOfDatabase = 1;
                        }
                    }
                }

                if (!isAMatchFound) {
                    responseOfDatabase = 0;
                }

                if (responseOfDatabase == 2) {
                    //signedIn = true;
                    System.out.println("status code is 200");
                    System.out.println("Successfully logged in!");
                    try {
                        writer("200~" + studentName);
                        loggedInUsers.add(split[1]);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                } else if (responseOfDatabase == 1) {
                    //signedIn = false;
                    System.out.println("status code is 401");
                    System.out.println("Password is incorrect!");
                    try {
                        writer("401~" + studentName);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                } else if (responseOfDatabase == 0) {
                    //signedIn = false;
                    System.out.println("status code is 404");
                    System.out.println("User not founded!");
                    try {
                        writer("404~");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                System.out.println(loggedInUsers.size());
                break;
            }
            case "signUp": {
                for (String s : split)
                    System.out.println(s);
                // checks the userName if it's taken, the response is zero and usr is not added
                boolean duplicate = false;
                String userName = split[2];
                for (Student user : Faculty.getStudents()) {
                    if (user.getId().equals(userName)) {
                        try {
                            writer("0");
                            duplicate = true;
                            break;
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }
                }
                if (!duplicate) {
                    Student user = new Student(split[1], split[2], split[3]);
                    Faculty.getStudents().add(user);
                    try {
                        Main.writeData(user.toString(), "src/models/students.txt");
                        writer("1");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
                break;
            }
            case "deleteAccount": {
                for (String s : split)
                    System.out.println(s);
                try {
                    // first, clear the database from the deleted account so that it isn't loaded
                    // next time we run the application
                    Main.removeLineFromFile("src/models/students.txt", split[2]);
                    // then delete the student from courses and current student list
                    for (Student student: Faculty.getStudents()) {
                        if (student.getId().equals(split[2])) {
                            Faculty.getStudents().remove(student);
                            break;
                        }
                    }
                    for (Course course: Faculty.getCourses()) {
                        course.getStudentList().remove(new Student(split[1], split[2], split[3]));
                    }
                    writer("200");
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }break;
            case "changePass": {
                try {
                    StringBuilder courses = new StringBuilder();
                    List<String> studentData = Main.sendStudentDataToChangePassword(split[1]);
                    for (String s: studentData) {
                        if (s.contains("/")) {
                            courses.append("~").append(s);
                        }
                    }
                    // create a new line after replacing the old password with a new one
                    // create and write changed info
                    String modifiedData = "";
                    if (studentData.getLast().contains("/")){
                        modifiedData = studentData.getFirst() + "~" + split[1] + "~" +
                                split[2] + courses;
                    } else {
                        modifiedData = studentData.getFirst() + "~" + split[1] + "~" +
                                split[2];
                    }
                    System.out.println(modifiedData);
                    Main.removeLineFromFile("src/models/students.txt", split[1]);
                    Main.writeData(modifiedData, "src/models/students.txt");
                    // we also have to update the data in Faculty's student array list
                    for (Student student: Faculty.getStudents()) {
                        if (student.getId().equals(split[1])) {
                            student.setPassword(split[2]);
                        }
                    }
                    writer("200");
                } catch (IOException e) {
                    e.printStackTrace();
                } break;
            }
//            case "GET: userInfo" : {
//                if (loggedInUsers.contains(split[1])){
//                    try {
//                        writer(DataBase.userinfo(split[1]));
//                    } catch (IOException e) {
//                        e.printStackTrace();
//                    }
//                }
//                break;
//            }
        }
    }
}
