public class Assignment {
    private final String name;
    private int deadline; // it shows how many days left until deactivation.
    private boolean status; // shows this assignment is active or not.
    public Assignment(String name, int deadline, boolean status) {
        this.name = name;
        this.deadline = deadline;
        this.status = status;
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
}

