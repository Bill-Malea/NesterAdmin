class Leave {
  final int id;
  final String name;
  final String dateRange;
  final String reason;
  final bool? status;
  final String supportDocuments;

  Leave({
    required this.supportDocuments,
    required this.id,
    required this.name,
    required this.dateRange,
    required this.reason,
    this.status,
  });

  static List<Leave> fromJsonList(List<dynamic> jsonList) {
    final List<Leave> leaves = [];
    for (final json in jsonList) {
      final bool? status = json['status'];
      final leave = Leave(
        id: json['id'],
        name: json['name'],
        dateRange: json['dateRange'],
        reason: json['reason'],
        status: status,
        supportDocuments: '',
      );
      if (status == true) {
        leaves.add(leave);
      } else if (status == false) {
        leaves.add(leave);
      } else if (status == null) {
        leaves.add(leave);
      }
    }
    return leaves;
  }
}
