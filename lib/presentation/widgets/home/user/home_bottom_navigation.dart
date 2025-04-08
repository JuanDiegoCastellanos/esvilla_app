import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/presentation/providers/user/pages_navigation_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBottomNavigation extends ConsumerStatefulWidget {
  const HomeBottomNavigation({
    super.key,
  });

  @override
  ConsumerState<HomeBottomNavigation> createState() => _HomeBottomNavigationState();
}

class _HomeBottomNavigationState extends ConsumerState<HomeBottomNavigation> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(pagesStateProvider);
    final pageIndex = Pages.values.indexOf(currentPage);

    return BottomNavigationBar(
      currentIndex: pageIndex,
      iconSize: 30,
      unselectedItemColor: Colors.black87,
      fixedColor: Colors.red,
      backgroundColor: Colors.indigoAccent,
      showUnselectedLabels: false,
      useLegacyColorScheme: false,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold
      ),
      unselectedLabelStyle: const TextStyle(
        color: Colors.black,
        backgroundColor: Colors.deepOrangeAccent
        ),
      onTap: (value) {
        AppLogger.i('Value: $value');
        final selectedPage = Pages.values[value];
        ref.read(pagesStateProvider.notifier).changePage(selectedPage);
      },
      items: const[
        BottomNavigationBarItem(
          icon:Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper_sharp),
          label: 'Noticias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'PQRS',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on_outlined),
          label: 'Links de Pago',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_pin),
          label: 'Perfil',
        ),
      ],
    );
  }
}