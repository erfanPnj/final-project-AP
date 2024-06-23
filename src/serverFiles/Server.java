package serverFiles;

import java.io.IOException;
import java.net.ServerSocket;

class Server {
    public static void main(String[] args) throws IOException {
        System.out.println("Welcome to the server!");
        ServerSocket serverSocket = new ServerSocket(8080);
        while (true) {
            System.out.println("Waiting for client...");
            new ClientHandler(serverSocket.accept()).start();
        }
    }
}
