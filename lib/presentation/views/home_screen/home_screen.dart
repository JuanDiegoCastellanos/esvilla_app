import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/providers/user/pages_navigation_bar_provider.dart';
import 'package:esvilla_app/presentation/views/home_screen/news_section_screen.dart';
import 'package:esvilla_app/presentation/views/home_screen/payment_links_section_screen.dart';
import 'package:esvilla_app/presentation/views/home_screen/pqrs_section_screen.dart';
import 'package:esvilla_app/presentation/views/home_screen/profile_section_screen.dart';
import 'package:esvilla_app/presentation/views/home_screen/schedule.mock.dart';
import 'package:esvilla_app/presentation/widgets/home/user/home_bottom_navigation.dart';
import 'package:esvilla_app/presentation/widgets/home/user/schedule_card.dart';
import 'package:esvilla_app/presentation/widgets/home/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

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
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 160),
                        child: Image.asset(
                          'assets/img/logoEsvillaOficial.png',
                        ),
                      ),
                    ),
                    const UserInfo(),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            width: double.infinity,
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Bienvenido Usuario ',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  WidgetSpan(child: Icon(
                    Icons.person,
                    color: Colors.red,
                    ),),
                  TextSpan(
                    text: '\nAqui podras ver las noticias, novedades, notificaciones públicas, tu perfil personal de esvilla, horarios, links de pago y solicitar PQRS.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nAgradecemos el respeto al momento de radicar un PQRS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  WidgetSpan(child: Icon(Icons.document_scanner, color: Colors.green,))
                  
                ],
              ),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
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
              'Horarios De Recoleccion',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Column(
              children: mockSchedule.days
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
                                color: Colors.black
                              ),
                              ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => ref.read(goRouterProvider).pop(),
                              child: const Icon(
                                Icons.close,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        content: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ListView(
                            children: e.timeBySectors
                                .map(
                                  (timeBySector) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                        color: Colors.blue.shade800,
                                        thickness: 2,
                                      ),
                                      Text(
                                        timeBySector.hour,
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
                                              (sector) => Chip(
                                                color: WidgetStateProperty.all<Color>(Colors.red),
                                                label: Text(
                                                  sector.name,
                                                  style: TextStyle(
                                                    color: Colors.white
                                                  ),
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
                  .toList()),
        ],
      ),
    );
  }
}
