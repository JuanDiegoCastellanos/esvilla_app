class UpdatePqrsRequestEntity {
  final String id;
  final String? subject;
  final String? description;
  final String? radicadorId;
  final String? radicadorName;
  final String? radicadorPhone;
  final String? radicadorEmail;
  final String? radicadorDocument;
  final String? status;
  final DateTime? closureDate;
  final String? resolution;
  final String? resolverName;

  const UpdatePqrsRequestEntity({
    required this.id,
    this.subject,
    this.description,
    this.radicadorId,
    this.radicadorName,
    this.radicadorPhone,
    this.radicadorEmail,
    this.radicadorDocument,
    this.status,
    this.closureDate,
    this.resolution,
    this.resolverName,
  });
}
