import 'package:flutter/material.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      fixedColor: Colors.blue.shade900,
      backgroundColor: Colors.blue.shade100,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.api_rounded),
          label: 'Gestion',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}