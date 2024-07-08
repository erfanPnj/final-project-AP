package serverFiles;

import models.Faculty;
import models.Main;

import java.io.IOException;
import java.net.ServerSocket;

public class Server {
    public static void main(String[] args) throws IOException {
        new Faculty("computerEngineering", 2);
        // After each launch of the program, we need to load the data from text files:
        // Main.loadStudentData(Faculty.getStudents()); // also loads teachers data and courses data
        Main.loadAssignmentData(Faculty.getAssignments());

        System.out.println("Welcome to the server!");
        ServerSocket serverSocket = new ServerSocket(8080);
        while (true) {
            System.out.println("Waiting for client...");
            new ClientHandler(serverSocket.accept()).start();
        }
    }
}
