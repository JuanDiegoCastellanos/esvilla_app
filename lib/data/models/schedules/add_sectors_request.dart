class AddSectorsRequest {
    final List<String> sectors;

    AddSectorsRequest({
        required this.sectors,
    });

    Map<String, dynamic> toJson() => {
        "sectores": List<dynamic>.from(sectors.map((x) => x)),
    };
}