class CreatePqrsRequest {
  final String subject;
  final String description;
  final String status;

  CreatePqrsRequest({
    required this.subject,
    required this.description,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        "asunto": subject,
        "descripcion": description,
        "estado": status,
      };
}
