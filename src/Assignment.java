public class Assignment {
    private final String name;
    private int deadline; // it shows how many days left until deactivation.
    private boolean status; // shows this assignment is active or not.
    private String courseName;
    public Assignment(String name, int deadline, boolean status, String courseName) {
        this.name = name;
        this.deadline = deadline;
        this.status = status;
        this.courseName = courseName;
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

    @Override
    public String toString() {
        return name + "-" + deadline + "-" + status + "-" + courseName;
    }
}

