package models;

public class Tasks {
    String name;
    String studentId;
    String definingDate;
    boolean isDone;

    public Tasks(String studentId, String name, String definingDate, boolean isDone) {
        this.studentId = studentId;
        this.name = name;
        this.definingDate = definingDate;
        this.isDone = isDone;
    }
}
