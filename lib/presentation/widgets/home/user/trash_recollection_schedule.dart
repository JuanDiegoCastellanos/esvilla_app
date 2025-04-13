class TrashRecollectionSchedule {
    final List<DaySchedule> days;

    TrashRecollectionSchedule({
        required this.days,
    });

}

class DaySchedule {
    final int id;
    final String name;
    final List<TimeBySector> timeBySectors;

    DaySchedule({
        required this.id,
        required this.name,
        required this.timeBySectors,
    });

}

class TimeBySector {
    final String hour;
    final List<Sector> sectors;

    TimeBySector({
        required this.hour,
        required this.sectors,
    });

}

class Sector {
    final int id;
    final String name;

    Sector({
        required this.id,
        required this.name,
    });

}


