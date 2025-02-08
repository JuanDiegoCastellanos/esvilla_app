import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/presentation/providers/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/widgets/home/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final List<MenuItem> items = [
    MenuItem(icon: Icons.person, label: 'Usuarios'),
    MenuItem(icon: Icons.receipt, label: 'Facturas'),
    MenuItem(icon: Icons.event_note, label: 'Reuniones'),
    MenuItem(icon: Icons.upload_file, label: 'Cargar Datos'),
    MenuItem(icon: Icons.home, label: 'Inmuebles'),
    MenuItem(icon: Icons.announcement, label: 'Anuncios'),
    MenuItem(icon: Icons.support_agent, label: 'Soporte'),
    MenuItem(icon: Icons.cloud_upload, label: 'Subir datos'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final auth = ref.read(authControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFE4F7FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'esvilla e.s.p',
                    style: TextStyle(
                      fontSize: 35,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.zero,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Juan Diego Castellanos'),
                      Text('1002676988')
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    auth.logout();
                    router.go('/login');
                  },
                  child: const Icon(
                    Icons.logout,
                    size: 40,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bienvenido Administrador',
              style: TextStyle(
                  color: Color.fromRGBO(47, 39, 125, 1), fontSize: 35),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 3, // Número de columnas
                crossAxisSpacing: 16.0, // Espacio entre columnas
                mainAxisSpacing: 16.0, // Espacio entre filas
                children: items
                    .map(
                      (item) => GestureDetector(
                        onTap: () {
                          print('${item.label} presionado');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF22A8D9), // Color de fondo del botón
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item.icon, size: 50.0, color: Colors.white),
                              SizedBox(height: 8.0),
                              FittedBox(
                                child: Text(
                                  item.label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromRGBO(47, 39, 125, 1),
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
