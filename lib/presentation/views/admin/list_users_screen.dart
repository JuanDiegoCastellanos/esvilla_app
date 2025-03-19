import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/presentation/widgets/home/admin/user_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListUsersScreen extends ConsumerStatefulWidget {
  const ListUsersScreen({super.key});

  @override
  ConsumerState<ListUsersScreen> createState() => _ListUsersScreenState();
}

class _ListUsersScreenState extends ConsumerState<ListUsersScreen> {
  final List<Map<String, dynamic>> users = [
    {
      "name": "Angie Lorena Moncada",
      "email": "M6oOe@example.com",
    },
    {
      "name": "Juan David Moncada",
      "email": "Jua9920@example.com",
    },
    {
      "name": "Manuel Moncada",
      "email": "Man9920@example.com",
    },
    {
      "name": "Luis Moncada",
      "email": "Lui9920@example.com",
    },
    {
      "name": "Pedro Moncada",
      "email": "Ped9920@example.com",
    },
  ];
  final searchController = TextEditingController();
  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filteredUsers = users;
  }

  void _filterUsers(String query) {
    // Función para filtrar usuarios
    if (query.isNotEmpty) {
      setState(() {
        filteredUsers = users
            .where((user) =>
                user['name'].toLowerCase().contains(query.toLowerCase()) ||
                user['email'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
    if (query.isEmpty) {
      setState(() {
        filteredUsers = users;
      });
    }
  }

  void _onDeleteTap(BuildContext context, String? name, String? email) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.white,
                title: const Text('Eliminar usuario'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('¿Estás seguro de eliminar este usuario?'),
                    ListTile(
                      leading:  CircleAvatar(child: Text(name?[0] ?? ''),),
                      title: Text(name ?? ''),
                      subtitle: Text(email ?? ''),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cerrar diálogo
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.white
                      ),
                      ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      setState(() {
                        filteredUsers.removeWhere((user) =>
                            user['name'] == name || user['email'] == email);
                      });
                      Navigator.of(context).pop(); // Cerrar diálogo
                    },
                    child: 
                    Text(
                      'Aceptar',
                      style: TextStyle(
                        color: Colors.white
                      ),
                      ),
                  ),
                ]));
  }


  @override
  Widget build(BuildContext context) {
    final goRouter = ref.read(goRouterProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFE4F7FF),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.lightBlue.shade700,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.red,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            goRouter.goNamed('admin');
          },
        ),
        title: TextField(
          controller: searchController,
          onChanged: _filterUsers,
          style: const TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400),
          decoration: const InputDecoration(
            hintText: 'Buscar por cédula o email',
            border: InputBorder.none,
            hintStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              icon: Icon(
                Icons.search,
                color: Colors.blue.shade900,
                size: 30,
              ),
              onPressed: () {
                final searchQuery = searchController.text;
                if (searchQuery.isEmpty) {
                  setState(() {
                    filteredUsers = users;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('El campo de busqueda no puede ser vacio .'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                _filterUsers(searchQuery);
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return UserListItem(
            userEmail: user['email'],
            userName: user['name'],
            onDeleteTap: () =>
                _onDeleteTap(context, user['name'], user['email']),
            onEditTap: () => goRouter.pushNamed('adminEditUser', extra: user),
          );
        },
      ),
    );
  }
}
