import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/pagination/pages_navigation_bar_provider.dart';
import 'package:esvilla_app/presentation/providers/schedules/list_schedules_state_notifier_provider.dart';
import 'package:esvilla_app/presentation/views/home_screen/news_section_screen.dart';
import 'package:esvilla_app/presentation/views/home_screen/payment_links_section_screen.dart';
import 'package:esvilla_app/presentation/views/home_screen/pqrs_section_screen.dart';
import 'package:esvilla_app/presentation/views/home_screen/profile_section_screen.dart';
import 'package:esvilla_app/presentation/widgets/home/user/home_bottom_navigation.dart';
import 'package:esvilla_app/presentation/widgets/home/user/schedule_card.dart';
import 'package:esvilla_app/presentation/widgets/home/user/trash_recollection_schedule.dart';
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
    final daysSchedule = ref.watch(scheduleRecollectionProvider);
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
              data: (data) {
                return Column(
                    children: daysSchedule.scheduleDays
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              //ref.read(goRouterProvider).pushNamed('schedule', extra: e);
                              // cambiar y aca mostrar mas bien un dialog con los horarios y los sectores
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.blue.shade100,
                                  title: Row(
                                    children: [
                                      Text(
                                        e.name,
                                        style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () =>
                                            ref.read(goRouterProvider).pop(),
                                        child: const Icon(
                                          Icons.close,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: ListView(
                                      children: e.timeBySectors
                                          .map(
                                            (timeBySector) => Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Divider(
                                                  color: Colors.blue.shade800,
                                                  thickness: 2,
                                                ),
                                                Text(
                                                  '${timeBySector.starthour} - ${timeBySector.endHour}',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Wrap(
                                                  spacing: 10,
                                                  runSpacing: 10,
                                                  children: timeBySector.sectors
                                                      .map(
                                                        (sector) => RawChip(
                                                          color:
                                                              WidgetStateProperty
                                                                  .all<Color>(
                                                                      Colors
                                                                          .red),
                                                          label: Column(
                                                            children: [
                                                              Text(
                                                                sector.name,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),


                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ScheduleCard(name: e.name),
                          ),
                        )
                        .toList());
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => const CircularProgressIndicator(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
}
