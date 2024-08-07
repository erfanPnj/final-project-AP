package models;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Student {
    private String name;
    private final String studentId;
    private String password;
    private int countOfCourses;
    private int countOfUnits;
    private final List<Course> courses = new ArrayList<>();
    private double allOfPoints = 0;
    private double thisSemesterPoints = 0;
    private double countOfAllOfGrades = 0;
    private double countOfThisSemesterGrades = 0;


    public Student(String name, String studentId, String password) {
        this.name = name;
        this.studentId = studentId;
        this.password = password;
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
        System.out.printf("%.2f%n", this.getAllTimeAverage());
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
            if (!coursesString.toString().contains(c.getCourseId())) {
                coursesString.append("~").append(c.getCourseId()).append(grade);
            }
        }
        return name + "~" + studentId + "~" + password + coursesString; // Like: Erfan-4022-ap-ec
    }

    public String getPassword() {
        return password;
    }

    public void setPassword (String password) {
        this.password = password;
    }

    public void setName(String name) {
        this.name = name;
    }

}
