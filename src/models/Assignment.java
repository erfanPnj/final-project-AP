package models;

public class Assignment {
    private final String name;
    private int deadline; // it shows how many days left until deactivation.
    private boolean status; // shows this assignment is active or not.
    private final String courseId;
    public Assignment(String name, int deadline, boolean status, String courseId) {
        this.name = name;
        this.deadline = deadline;
        this.status = status;
        this.courseId = courseId;
    }

    public String getName() {
        return name;
    }

    public int getDeadline() {
        return deadline;
    }

    public void setDeadline(int deadline) {
        this.deadline = deadline;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return name + "~" + deadline + "~" + status + "~" + courseId;
    }
}

