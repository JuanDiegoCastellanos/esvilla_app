class UpdateSectorsScheduleRequest {
    final List<String> sectores;

    UpdateSectorsScheduleRequest({
        required this.sectores,
    });

    Map<String, dynamic> toJson() => {
        "sectores": List<dynamic>.from(sectores.map((x) => x)),
    };
}
