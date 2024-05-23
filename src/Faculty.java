import java.util.ArrayList;
import java.util.List;


// works as an interface between Main.java and databases(text files)
public class Faculty {
    private static int semester;
    private static final List<Student> students = new ArrayList<>();
    private static final List<Teacher> teachers = new ArrayList<>();
    private static final List<Course> courses = new ArrayList<>();
    private static final List<Assignment> assignments = new ArrayList<>();

    public Faculty(String name, int semester) {
        Faculty.semester = semester;
    }
    public void setSemester(int semester) {
        Faculty.semester = semester;
    }
    public static int getSemester() {
        return Faculty.semester;
    }

    public static List<Student> getStudents() {
        return students;
    }

    public static List<Teacher> getTeachers() {
        return teachers;
    }

    public static List<Course> getCourses() {
        return courses;
    }

    public static List<Assignment> getAssignments() {return assignments;}

    public static void changeCourseStatus (Course course) {
        for (Course c : Faculty.courses) {
            if (c.getCourseName().equals(course.getCourseName())) {
                if (c.isStatus()) {
                    c.setStatus(false);
                } else {
                    c.setStatus(true);
                }
            }
        }
    }


}
