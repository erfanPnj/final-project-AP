import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Student implements Serializable {
    private final String name;
    private final String studentId;
    private int countOfCourses;
    private int countOfUnits;
    private final List<Course> courses = new ArrayList<>();
    private double allOfPoints = 0;
    private double thisSemesterPoints = 0;
    private double countOfAllOfGrades = 0;
    private double countOfThisSemesterGrades = 0;


    public Student(String name, String studentId) {
        this.name = name;
        this.studentId = studentId;
        Faculty.getStudents().add(this);
    }

    public void setAllOfPoints(double allOfPoints) {
        this.allOfPoints = allOfPoints;
    }

    public void setThisSemesterPoints(double thisSemesterPoints) {
        this.thisSemesterPoints = thisSemesterPoints;
    }

    public void setCountOfAllOfGrades(double countOfAllOfGrades) {
        this.countOfAllOfGrades = countOfAllOfGrades;
    }

    public void setCountOfThisSemesterGrades(double countOfGrades) {
        this.countOfThisSemesterGrades = countOfGrades;
    }

    public void setCountOfCourses(int countOfCourses) {
        this.countOfCourses = countOfCourses;
    }

    public void setCountOfUnits(int countOfUnits) {
        this.countOfUnits = countOfUnits;
    }

    public String getName() {
        return name;
    }

    public String getId() {
        return studentId;
    }

    public int getCountOfCourses() {
        return countOfCourses;
    }

    public int getCountOfUnits() {
        return countOfUnits;
    }

    public List<Course> getCourses() {
        return courses;
    }

    public double getCountOfAllOfGrades() {
        return countOfAllOfGrades;
    }

    public double getCountOfThisSemesterGrades() {
        return countOfThisSemesterGrades;
    }

    public double getAllTimeAverage() {
        return allOfPoints / countOfAllOfGrades;
    }

    public double getThisSemesterAverage() {
        return thisSemesterPoints / countOfThisSemesterGrades;
    }

    public double getAllOfPoints() {
        return allOfPoints;
    }

    public double getThisSemesterPoints() {
        return thisSemesterPoints;
    }

    public void addCourseAndUnit (Course course) {
        this.courses.add(course);
        this.countOfUnits += course.getCountOfUnits();
    }

    public void printStudentCourses () {
        for (Course c : courses) {
            System.out.println(c.getCourseName());
        }
    }

    public void printStudentAllTimeAvg () {
        System.out.println(this.getAllTimeAverage());
    }

    public void printRegisteredAvg () {
        System.out.println(this.getThisSemesterAverage());
    }

    public void printCountOfUnits () {
        System.out.println(this.getCountOfUnits());
    }


}
