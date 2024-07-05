package models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Course {
    private final String courseId;
    private final String courseName;
    private final Teacher courseTeacher;
    private final int countOfUnits;
    private List<Student> studentList = new ArrayList<>();
    private boolean status;
    private int countOfAssignments = 0;
    private final String examDate; // it must be a string in the format of Year.Month.Day: 2024.4.10;
    private List<Assignment> activeProjects = new ArrayList<>();
    private List<Assignment> deactiveProjects = new ArrayList<>();
    private int presentedSemester;
    private Map<Student, Double> scores = new HashMap<>();

    public Course(String courseName, Teacher courseTeacher, int countOfUnits, String examDate, int presentedSemester, boolean status, String courseId) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.courseTeacher = courseTeacher;
        if (!courseTeacher.getPresentedCourses().contains(this))
            courseTeacher.addCourseToThisTeacher(this);
        this.countOfUnits = countOfUnits;
        this.examDate = examDate;
        this.presentedSemester = presentedSemester;
        this.status = status;
    }

    @Override
    public String toString() {
        return courseName + "~" + courseTeacher.getId() + "~" + countOfUnits + "~" + examDate + "~" + status + "~" + courseId + "~" + countOfAssignments;
    }

    public void setStudentList(List<Student> studentList) {
        this.studentList = studentList;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public void setCountOfAssignments(int countOfAssignments) {
        this.countOfAssignments = countOfAssignments;
    }

    public void setActiveProjects(List<Assignment> activeProjects) {
        this.activeProjects = activeProjects;
    }

    public void setPresentedSemester(int presentedSemester) {
        this.presentedSemester = presentedSemester;
    }

    public void setScores (Student student, double point) {
        scores.put(student, point);
    }

    public String getCourseName() {
        return courseName;
    }

    public Teacher getCourseTeacher() {
        return courseTeacher;
    }

    public int getCountOfUnits() {
        return countOfUnits;
    }

    public List<Student> getStudentList() {
        return studentList;
    }

    public boolean isStatus() {
        return status;
    }

    public int getCountOfAssignments() {
        return countOfAssignments;
    }

    public String getExamDate() {
        return examDate;
    }

    public List<Assignment> getActiveProjects() {
        return activeProjects;
    }

    public List<Assignment> getDeactiveProjects() {
        return deactiveProjects;
    }

    public int getPresentedSemester() {
        return presentedSemester;
    }

    public String getCourseId() {
        return courseId;
    }

    public Map<Student, Double> getScores() {
        return scores;
    }

    public void printStudentList () {
        for (Student s : studentList) {
            System.out.println(s.getName());
        }
    }

    public void addStudent (Student student) {
        if (this.isStatus()) {
            studentList.add(student);
            // adding student to a course means adding that course to that student courses and unit list!
            student.getCourses().add(this);
            student.setCountOfCourses(student.getCountOfCourses() + 1);
            student.setCountOfUnits(student.getCountOfUnits() + this.countOfUnits);
        }
    }

    public void eliminateStudent (Student student) {
        studentList.removeIf(s -> s.getId().equals(student.getId()));
        // after eliminating a student from a course, it should drop the course and unit:
        student.setCountOfCourses(student.getCountOfCourses() - 1);
        student.setCountOfUnits(student.getCountOfUnits() - this.countOfUnits);
        student.getCourses().remove(this); // remove the course from student's courses list
        for (Student k : scores.keySet()) {
            if (k.getId().equals(student.getId())) {
                scores.remove(k);
                // after removing the target student, to avoid ConcurrentModificationError, we break this loop
                break;
            }
        }
    }

    public double highestScore () {
        List<Double> score = new ArrayList<>(scores.values()); // extract grades and make a list out of them
        score.sort((Double::compareTo));
        return score.getLast();
    }


}
