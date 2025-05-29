import 'package:esvilla_app/presentation/providers/auth/auth_controller_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/pagination/pages_navigation_bar_provider.dart';
import 'package:esvilla_app/presentation/providers/schedules/list_schedules_state_notifier_provider.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedule_model_presentation.dart';
import 'package:esvilla_app/presentation/views/home_screen/news_section_screen.dart';
import 'package:esvilla_app/presentation/views/home_screen/payment_links_section_screen.dart';
import 'package:esvilla_app/presentation/views/home_screen/pqrs_section_screen.dart';
import 'package:esvilla_app/presentation/views/home_screen/profile_section_screen.dart';
import 'package:esvilla_app/presentation/widgets/home/user/home_bottom_navigation.dart';
import 'package:esvilla_app/presentation/widgets/home/user_info.dart';
import 'package:esvilla_app/presentation/widgets/shared/title_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authControllerProvider.notifier);
    final currentPage = ref.watch(pagesStateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE4F7FF),
      body: SafeArea(
        child: Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 160),
                        child: Image.asset(
                          'assets/img/logoEsvillaOficial.png',
                        ),
                      ),
                    ),
                    SizedBox(width: 120, child: const UserInfo()),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          auth.logout();
                        },
                        child: const Icon(
                          Icons.logout,
                          color: Colors.red,
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                endIndent: 10,
                indent: 10,
                thickness: 2,
                color: Colors.blue.shade900,
              ),
            ],
          ),
          Expanded(
            child: _getPage(currentPage),
          ),
        ]),
      ),
      bottomNavigationBar: const HomeBottomNavigation(),
    );
  }

  Widget _getPage(Pages page) {
    switch (page) {
      case Pages.home:
        return _buildHomeContent();
      case Pages.news:
        return NewsSectionScreen();
      case Pages.pqrs:
        return const PqrsSectionScreen();
      case Pages.links:
        return const PaymentLinksSectionScreen();
      case Pages.profile:
        return const ProfileSectionScreen();
    }
  }

  Widget _buildHomeContent() {
    final schedulesAsync = ref.watch(listSchedulesProvider);
    return RefreshIndicator(
      onRefresh: () async {
        // Invalidamos el proveedor
        ref.invalidate(listSchedulesProvider);
        // Esperamos explícitamente a que se complete la recarga
        return ref.read(listSchedulesProvider.future);
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 10,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              width: double.infinity,
              child: const TitleSection(
                titleText: 'Horarios De Recoleccion',
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              width: double.infinity,
              child: const Text(
                'Estimado usuario en esta sección puede encontrar los horarios de recolección de basuras ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
            ),
            schedulesAsync.when(
              data: (schedules) {
                final List<ScheduleModelPresentation> sortedSchedules =
                    List.from(schedules);
                sortedSchedules.sort((a, b) {
                  final dayOrder = [
                    'lunes',
                    'martes',
                    'miércoles',
                    'jueves',
                    'viernes',
                    'sábado',
                    'domingo'
                  ];
                  final dayA =
                      a.days!.isNotEmpty ? a.days!.first.toLowerCase() : '';
                  final dayB =
                      b.days!.isNotEmpty ? b.days!.first.toLowerCase() : '';
                  return dayOrder
                      .indexOf(dayA)
                      .compareTo(dayOrder.indexOf(dayB));
                });
                return Column(
                  children: sortedSchedules.map((schedule) {
                    final dayOrder = [
                      'lunes',
                      'martes',
                      'miércoles',
                      'jueves',
                      'viernes',
                      'sábado',
                      'domingo'
                    ];
                    final sortedDays = List<String>.from(schedule.days!);
                    sortedDays.sort((a, b) {
                      final indexA = dayOrder.indexOf(a.toLowerCase());
                      final indexB = dayOrder.indexOf(b.toLowerCase());
                      return indexA.compareTo(indexB);
                    });
                    final daysText = sortedDays.join(', ');
                    //final daysText = schedule.days!.join(', ');
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Card(
                        color: Colors.blue.shade600,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () => _showScheduleDetails(context, schedule),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          overflow: TextOverflow.clip,
                                          daysText.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: (schedule.active ?? false)
                                            ? Colors.green.shade100
                                            : Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        (schedule.active ?? false)
                                            ? 'Activo'
                                            : 'Inactivo',
                                        style: TextStyle(
                                          color: (schedule.active ?? false)
                                              ? Colors.green.shade800
                                              : Colors.red.shade800,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 18, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${schedule.startTime}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.text_snippet_outlined,
                                        size: 18, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${schedule.observations}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.delete_outline,
                                        size: 17, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        schedule.garbageType ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (schedule.associatedSectors!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 17,
                                          color: Colors.white),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${schedule.associatedSectors!.length} sectores',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      'Toca para ver detalles',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              error: (error, stackTrace) => Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.error_outline,
                        size: 48, color: Colors.red.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar horarios',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => Container(
                padding: const EdgeInsets.all(40),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {
                  ref.invalidate(listSchedulesProvider);
                  return ref.read(listSchedulesProvider.future);
                },
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showScheduleDetails(
      BuildContext context, ScheduleModelPresentation schedule) {
    final dayOrder = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo'
    ];
    final sortedDays = List<String>.from(schedule.days!);
    sortedDays.sort((a, b) {
      final indexA = dayOrder.indexOf(a.toLowerCase());
      final indexB = dayOrder.indexOf(b.toLowerCase());
      return indexA.compareTo(indexB);
    });
    final daysText = sortedDays.join(', ');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.blue.shade50,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    daysText.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  Text(
                    '${schedule.startTime}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.close,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                    'Estado',
                    schedule.active! ? 'Activo' : 'Inactivo',
                    schedule.active! ? Colors.green : Colors.red),
                const SizedBox(height: 16),
                _buildDetailRow(
                    'Tipo de residuo', schedule.garbageType!, Colors.blue),
                const SizedBox(height: 16),
                if (schedule.observations != null &&
                    schedule.observations!.isNotEmpty) ...[
                  _buildDetailSection('Observaciones', schedule.observations),
                  const SizedBox(height: 16),
                ],
                if (schedule.associatedSectors!.isNotEmpty) ...[
                  _buildDetailSection(
                      'Sectores (${schedule.associatedSectors!.length})', null),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: schedule.associatedSectors!.map<Widget>((sector) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade300),
                        ),
                        child: Text(
                          sector,
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                if (schedule.associatedSectors!.isEmpty) ...[
                  _buildDetailSection(
                      'Sectores Asociados (${schedule.associatedSectors!.length})',
                      null),
                  const SizedBox(height: 8),
                ],
                _buildDetailRow(
                    'Creado', _formatDate(schedule.createdAt), Colors.grey),
                if (schedule.updatedAt != null) ...[
                  const SizedBox(height: 8),
                  _buildDetailRow('Actualizado',
                      _formatDate(schedule.updatedAt), Colors.grey),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection(String title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey.shade800,
          ),
        ),
        if (content != null) ...[
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}
