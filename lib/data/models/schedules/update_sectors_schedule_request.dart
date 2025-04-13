class UpdateSectorsScheduleRequest {
    final List<String> sectors;

    UpdateSectorsScheduleRequest({
        required this.sectors,
    });

    Map<String, dynamic> toJson() => {
        "sectores": List<dynamic>.from(sectors.map((x) => x)),
    };
}
