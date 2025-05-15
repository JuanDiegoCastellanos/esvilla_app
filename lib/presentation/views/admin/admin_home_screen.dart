import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_state_notifier.dart';
import 'package:esvilla_app/presentation/widgets/home/admin/card_home.dart';
import 'package:esvilla_app/presentation/widgets/home/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminHome extends ConsumerWidget {
  const AdminHome({super.key});

  _showDialogInProgress(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Esta etapa de desarrollo, muy pronto...'),
      ),
    );
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final goRouter = ref.read(goRouterProvider);
    final List<CardHome> homeItems = <CardHome>[
      CardHome(
        onTap: () => goRouter.goNamed('adminListUsers'),
        cardIcon: Image.asset(
                  'assets/img/admin/multitud.png',
                  width: 70,
                  height: 70,
                  ),
        cardText: 'Usuarios',
      ),
      CardHome(
        onTap: () => goRouter.goNamed('adminListAnnouncements'),
        cardIcon: Image.asset(
                  'assets/img/admin/periodico.png',
                  width: 70,
                  height: 70,
                  ),
        cardText: 'Anuncios',
      ),
      CardHome(
        onTap: () => goRouter.goNamed('adminListPqrs'),
        cardIcon: Image.asset(
                  'assets/img/admin/atencion-al-cliente.png',
                  width: 70,
                  height: 70,
                  ),
        cardText: 'PQRS',
      ),
      CardHome(
        onTap: () => _showDialogInProgress(context),
        cardIcon: Image.asset(
                  'assets/img/admin/zona-horaria.png',
                  width: 70,
                  height: 70,
                  ),
        cardText: 'Horarios',
      ),
      CardHome(
        onTap: () => _showDialogInProgress(context),
        cardIcon: Image.asset(
                  'assets/img/admin/ubicacion.png',
                  width: 70,
                  height: 70,
                  ),
        cardText: 'Sectores',
      ),
    ];
    return Scaffold(
        backgroundColor: const Color(0xFFE4F7FF),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const EsvillaAppBar(),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: homeItems,
                    
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class EsvillaAppBar extends ConsumerWidget {
  const EsvillaAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authControllerProvider.notifier);
    return SizedBox(
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
            padding: const EdgeInsets.only(right: 5),
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
    );
  }
}