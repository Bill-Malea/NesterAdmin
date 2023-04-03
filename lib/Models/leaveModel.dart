class Leave {
  final String id;
  final String name;
  final String employid;
  final String from;
  final String to;
  final String reason;
  final bool? status;
  final String supportDocuments;

  Leave({
    required this.supportDocuments,
    required this.id,
    required this.employid,
    required this.name,
    required this.from,
    required this.to,
    required this.reason,
    required this.status,
  });
}
