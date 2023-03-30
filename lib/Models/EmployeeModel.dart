class Employee {
  final String id;
  final String dbid;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String department;
  final String salary;
  final String role;
  final String joineDate;
  Employee({
    required this.dbid,
    required this.department,
    required this.gender,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.salary,
    required this.joineDate,
  });

  factory Employee.fromJson(
    json,
  ) {
    return Employee(
      dbid: json['dbid'],
      role: json['name'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      department: json['department'] ?? '',
      gender: json['gender'] ?? '',
      joineDate: json['joinDate'] ?? '',
      salary: json['salary'] ?? '',
    );
  }
}
