import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Student {
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

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (!(object instanceof Student student)) return false;
        return Objects.equals(name, student.name) && Objects.equals(studentId, student.studentId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, studentId);
    }

    public void addCourseAndUnit (Course course) {
        //course.addStudent(this);
        course.getStudentList().add(this);
        this.courses.add(course);
        this.countOfUnits += course.getCountOfUnits();
        this.countOfCourses += 1;
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


    @Override
    public String toString() {
        StringBuilder coursesString = new StringBuilder(); // this will show the course part in students.txt
        for (Course c : courses) {
            StringBuilder grade = new StringBuilder();
            if (c.getScores().containsKey(this)) { // check if there is a grade related to this student in course c
                grade.append("/").append(c.getScores().get(this));
            }
            coursesString.append("-").append(c.getCourseName()).append(grade);
        }
        return name + "-" + studentId + coursesString; // Like: Erfan-4022-ap-ec
    }
}
