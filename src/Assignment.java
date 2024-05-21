import java.io.Serializable;

public class Assignment implements Serializable {
    private final String name;
    private int deadline; // it shows how many days left until deactivation.
    private boolean status; // shows this assignment is active or not.
    public Assignment(String name, int deadline, boolean status) {
        this.name = name;
        this.deadline = deadline;
        this.status = status;
        Faculty.getAssignments().add(this);
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
        return name + "-" + deadline + "-" + status;
    }
}

