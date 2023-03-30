// ignore: file_names
class Attendance {
  final DateTime checkin;
  final DateTime checkout;

  Attendance({
    required this.checkin,
    required this.checkout,
  });
}

class UserAttendance {
  final String userid;
  final List<Attendance> attendancelist;
  final String averagetime;

  UserAttendance({required this.userid, required this.attendancelist, required this.averagetime});
}
