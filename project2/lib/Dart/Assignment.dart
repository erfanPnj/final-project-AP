class Assignment {
  String name;
  int deadline;
  bool status;
  String courseId;
  String definingDate;
  List<String> get returnDefiningDate => definingDate.split('.');

  Assignment(this.name, this.deadline, this.status, this.courseId, this.definingDate);
}