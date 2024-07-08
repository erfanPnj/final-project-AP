package models;

import java.util.ArrayList;
import java.util.List;

public class Teacher {
    private final String name;
    private final String id;
    private final int presentedCoursesCount;
    private List<Course> presentedCourses = new ArrayList<>();

    public Teacher(String name, String id, int presentedCoursesCount) {
        this.name = name;
        this.id = id;
        this.presentedCoursesCount = presentedCoursesCount;
    }

    @Override
    public String toString() {
        StringBuilder coursesString = new StringBuilder();
        for (Course c : presentedCourses) {
            if (c.getCourseTeacher().getId().equals(this.id))
                coursesString.append("~").append(c.getCourseId());
        }
        return name + "~" + id + "~" + presentedCoursesCount + coursesString; // Like: Ali-1234-3
    }

    public String getName() {
        return name;
    }

    public void setPresentedCourses(List<Course> presentedCourses) { // we can use this instead of addCourseToThisTeacher for adding a list of courses
        this.presentedCourses = presentedCourses;
    }

    public void addCourseToThisTeacher (Course course) {
        if (presentedCoursesCount == presentedCourses.size()) {
            System.out.println("This teacher has reached to maximum course count!");
            return;
        }
        presentedCourses.add(course);
    }

    public void removeCourseFromThisTeacher (Course course) {
        this.getPresentedCourses().remove(course);
    }

    public String getId() {
        return id;
    }

    public List<Course> getPresentedCourses() {
        return presentedCourses;
    }

    public void addStudentToACourse (Student student, Course course) {
        if (course.isStatus()) {
            course.addStudent(student);
            // when a teacher adds a student to a course, units and the course should be attached to student, it goes both ways :)
            student.addCourseAndUnit(course);
        }
    }

    public void removeStudentFromACourse (Student student, Course course) {
        course.eliminateStudent(student);
    }

    public void defineNewAssignment (String courseId, String assignmentName,
                                     boolean assignmentStatus, int deadline) {
        for (Course c : presentedCourses) {
            if (c.getCourseId().equals(courseId)) {
                c.getActiveProjects().add(new Assignment(assignmentName, deadline, assignmentStatus, c.getCourseId(), Main.getTodayDate()));
                c.setCountOfAssignments(c.getCountOfAssignments() + 1);
            }
        }
    }

    public void deleteAnAssignment (String courseId, String assignmentName) {
        for (int i = 0; i < presentedCoursesCount; i++) { // using enhanced for loop causes ConcurrentModificationException
            // so we use traditional i and j loops:
            if (presentedCourses.get(i).getCourseId().equals(courseId)) {
                // after finding the proper course, we check whether it is an active ot a deactivated project.
                for (int j = 0; j < presentedCourses.get(i).getActiveProjects().toArray().length; j++) {
                    // got to presented courses of this teacher -> get the target course -> get the target assignment and
                    // compare its name to the given parameter:
                    if (presentedCourses.get(i).getActiveProjects().get(j).getName().equals(assignmentName)) { // matching the assignment using its name:
                        presentedCourses.get(i).getActiveProjects().remove(presentedCourses.get(i).getActiveProjects().get(j)); // remove the target
                        presentedCourses.get(i).setCountOfAssignments(presentedCourses.get(i).getCountOfAssignments() - 1); // decrease count of assignments after deletion
                    }
                }
                for (int j = 0; j < presentedCourses.get(i).getDeactiveProjects().toArray().length; j++) {
                    if (presentedCourses.get(i).getDeactiveProjects().get(j).getName().equals(assignmentName)) {
                        presentedCourses.get(i).getDeactiveProjects().remove(presentedCourses.get(i).getActiveProjects().get(j));
                        presentedCourses.get(i).setCountOfAssignments(presentedCourses.get(i).getCountOfAssignments() - 1);// decrease count of assignments after deletion
                    }
                }
                break;
            }
        }
    }

    public void rateStudents (String courseId, String studentId, double point) {
        for (Course c : presentedCourses) {
            if (c.getCourseId().equals(courseId)) {
                for (Student s : c.getStudentList()) {
                    if (s.getId().equals(studentId)) {
                        // given grade is added to scores of this course to use for finding higher score (highestScore() in Course.java):
                        c.getScores().put(s, point);
                        s.setCountOfAllOfGrades(s.getCountOfAllOfGrades() + 1); // A grade has been added.
                        s.setAllOfPoints(s.getAllOfPoints() + point);
                        if (c.getPresentedSemester() == Faculty.getSemester()) {
                            s.setCountOfThisSemesterGrades(s.getCountOfThisSemesterGrades() + 1); // A grade has been added for this semester.
                            s.setThisSemesterPoints(s.getThisSemesterPoints() + point);
                        }
                    }
                }
            }
        }
    }

    public void changeAssignmentDeadline (String assignmentName, int newDeadline) {
        for (Course c : presentedCourses) {
            for (Assignment a : c.getActiveProjects()) {
                if (a.getName().equals(assignmentName)) {
                    a.setDeadline(newDeadline);
                }
            }
        }
    }

}
