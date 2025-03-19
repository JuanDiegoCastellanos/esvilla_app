import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final String name;
  const ScheduleCard({
    super.key,
    required this.name
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.shade300,
                    Colors.lightBlue.shade900
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icono representativo
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.schedule,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  // Texto descriptivo
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Horarios de Recolección',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Icono de navegación (opcional)
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}