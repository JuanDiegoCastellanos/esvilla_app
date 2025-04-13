class PqrsEntity {
  final String id;
  final String subject;
  final String description;
  final String radicadorId;
  final String radicadorName;
  final String radicadorPhone;
  final String radicadorEmail;
  final String radicadorDocument;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? closureDate;

  const PqrsEntity({
    required this.id,
    required this.subject,
    required this.description,
    required this.radicadorId,
    required this.radicadorName,
    required this.radicadorPhone,
    required this.radicadorEmail,
    required this.radicadorDocument,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.closureDate
  });
}

