import 'package:esvilla_app/presentation/widgets/home/user/home_bottom_navigation.dart';
import 'package:esvilla_app/presentation/widgets/home/user/trash_recollection_schedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ScheduleScreen extends StatelessWidget {
  final DaySchedule daySchedule;
  const ScheduleScreen({super.key, required this.daySchedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Horario para el día ',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: daySchedule.name,
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.indigo.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    children:
                    [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                          children: [
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'Hora',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'Sectores',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                          ),
                          ...daySchedule.timeBySectors.map((timeBySector) => TableRow(
                            children:[
                          TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue.shade300,
                                  ),
                                  child:  Text(
                                    timeBySector.hour,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  padding: const EdgeInsets.all(8.0),
                                  child:  CupertinoScrollbar(
                                    controller: ScrollController(),
                                    thickness: 4,
                                    thumbVisibility: true,
                                    radius: const Radius.circular(10),
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          timeBySector.sectors.map((sector) => sector.name).join(', '),
                                          style: TextStyle(
                                              color: Colors.indigo.shade400,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomNavigation(),
    );
  }
}
