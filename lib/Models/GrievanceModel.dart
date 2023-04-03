class Grievance {
  final String username;
  final String title;
  final String userid;
  final String id;
  final String? reply;
  final String department;
  final DateTime? dateTime;
  final String? description;
  Grievance(
      {required this.username,
      required this.id,
      required this.description,
      required this.department,
      required this.dateTime,
      required this.title,
      required this.userid,
      required this.reply});
}
