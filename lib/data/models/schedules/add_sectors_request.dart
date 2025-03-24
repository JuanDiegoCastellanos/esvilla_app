class AddSectorsRequest {
    final List<String> sectores;

    AddSectorsRequest({
        required this.sectores,
    });

    Map<String, dynamic> toJson() => {
        "sectores": List<dynamic>.from(sectores.map((x) => x)),
    };
}