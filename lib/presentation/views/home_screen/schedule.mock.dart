import 'package:esvilla_app/presentation/widgets/home/user/trash_recollection_schedule.dart';

final List<DaySchedule> listDays = [
  DaySchedule(
    id: 2,
    name: 'Martes',
    timeBySectors: [
      TimeBySector(
        hour: '6:00 pm',
        sectors: [
          Sector(
            id: 4,
            name: 'Las hadas',
          ),
          Sector(
            id: 5,
            name: 'Los duendes',
          ),
          Sector(
            id: 6,
            name: 'Los magos',
          ),
        ],
      ),
    ],
  ),
  DaySchedule(
    id: 1,
    name: 'Lunes',
    timeBySectors: [
      TimeBySector(
        hour: '8:00 am',
        sectors: [
          Sector(
            id: 1,
            name: 'Barrio las rocas',
          ),
          Sector(
            id: 2,
            name: 'El eden',
          ),
          Sector(
            id: 3,
            name: 'El bosque',
          ),
        ],
      ),
    ],
  ),
  DaySchedule(
    id: 3,
    name: 'Miercoles',
    timeBySectors: [
      TimeBySector(
        hour: '8:00 am',
        sectors: [
          Sector(
            id: 1,
            name: 'Las princesas',
          ),
          Sector(
            id: 2,
            name: 'Los princesos',
          ),
          Sector(
            id: 3,
            name: 'Los reyes',
          ),
        ],
      ),
    ],
  ),
  DaySchedule(
    id: 4,
    name: 'Jueves',
    timeBySectors: [
      TimeBySector(
        hour: '8:00 am',
        sectors: [
          Sector(
            id: 1,
            name: 'Sector 1',
          ),
          Sector(
            id: 2,
            name: 'Sector 2',
          ),
          Sector(
            id: 3,
            name: 'Sector 3',
          ),
        ],
      ),
    ],
  ),
  DaySchedule(
    id: 5,
    name: 'Viernes',
    timeBySectors: [
      TimeBySector(
        hour: '8:00 am',
        sectors: [
          Sector(
            id: 1,
            name: 'Sector 1',
          ),
          Sector(
            id: 2,
            name: 'Sector 2',
          ),
          Sector(
            id: 3,
            name: 'Sector 3',
          ),
        ],
      ),
    ],
  ), DaySchedule(
    id: 6,
    name: 'Sabado',
    timeBySectors: [
      TimeBySector(
        hour: '8:00 am',
        sectors: [
          Sector(
            id: 1,
            name: 'Sector 1',
          ),
          Sector(
            id: 2,
            name: 'Sector 2',
          ),
          Sector(
            id: 3,
            name: 'Sector 3',
          ),
        ],
      ),

      TimeBySector(
        hour: '10:00 am',
        sectors: [
          Sector(
            id: 1,
            name: 'La piedrera',
          ),
          Sector(
            id: 2,
            name: 'El juanito',
          ),
          Sector(
            id: 3,
            name: 'La lorenita',
          ),
        ],
      ),

      TimeBySector(
        hour: '12:00 pm',
        sectors: [
          Sector(
            id: 1,
            name: 'La 272828dhdhdhdhd',
          ),
          Sector(
            id: 2,
            name: 'El jxjxdjdjdjdx',
          ),
          Sector(
            id: 3,
            name: 'La oosisisdjdji',
          ),
        ],
      ),
    ],
  ),
  DaySchedule(
    id: 7,
    name: 'Domingo',
    timeBySectors: [
      TimeBySector(
        hour: '8:00 am',
        sectors: [
          Sector(
            id: 1,
            name: 'Sector 1',
          ),
          Sector(
            id: 2,
            name: 'Sector 2',
          ),
          Sector(
            id: 3,
            name: 'Sector 3',
          ),
        ],
      ),
    ],
  )
];

final TrashRecollectionSchedule mockSchedule = TrashRecollectionSchedule(
  days: listDays..sort((DaySchedule a, DaySchedule b) => a.id.compareTo(b.id)),
);


// tengo un problema, la tabla no se actualiza sola si llegan mas datos
// posible solucion es cuando llegue data desde el backend y se maneje con riverpod