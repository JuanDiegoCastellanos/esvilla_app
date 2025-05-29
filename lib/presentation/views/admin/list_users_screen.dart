import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/presentation/providers/user/all_users_controller_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_model_presentation.dart';
import 'package:esvilla_app/presentation/views/admin/admin_home_screen.dart';
import 'package:esvilla_app/presentation/widgets/home/admin/user_list_item.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListUsersScreen extends ConsumerStatefulWidget {
  const ListUsersScreen({super.key});

  @override
  ConsumerState<ListUsersScreen> createState() => _ListUsersScreenState();
}

class _ListUsersScreenState extends ConsumerState<ListUsersScreen> {
  List<UserPresentationModel> users = [];
  final searchController = TextEditingController();
  List<UserPresentationModel> filteredUsers = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterUsers(String query) {
    // Función para filtrar usuarios
    if (query.isNotEmpty) {
      setState(() {
        filteredUsers = users
            .where((user) =>
                user.name!.toLowerCase().contains(query.toLowerCase()) ||
                user.email!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
    if (query.isEmpty) {
      setState(() {
        filteredUsers = users;
      });
    }
  }

  void _onDeleteTap(BuildContext context, UserPresentationModel user) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.blue.shade100,
                title: const Text('Eliminar usuario'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('¿Estás seguro de eliminar este usuario?'),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.lightBlue.shade300,
                        child: Text(user.name?[0] ?? ''),
                      ),
                      title: Text(user.name ?? ''),
                      subtitle: Text(
                        user.email ?? '',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blueGrey),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cerrar diálogo
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      ref.read(allUsersControllerProvider.notifier).removeUser(user.id!);
                      Navigator.of(context).pop(); // Cerrar diálogo
                    },
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    users = ref.watch(allUsersControllerProvider);

    final searchQuery = searchController.text;
    filteredUsers = searchQuery.isEmpty
        ? users
        : users.where((user) {
            final lowerQuery = searchQuery.toLowerCase();
            return user.name?.toLowerCase().contains(lowerQuery) ??
                false || user.email!.toLowerCase().contains(lowerQuery);
          }).toList();

    final goRouter = ref.read(goRouterProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFE4F7FF),
      body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => ref.read(allUsersControllerProvider.notifier).loadUsers(),
            child: Column(
                    children: [
            EsvillaAppBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                height: 70,
                width: double.infinity,
                color: const Color.fromRGBO(47, 39, 125, 1),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: searchController,
                          onChanged: _filterUsers,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                          decoration: const InputDecoration(
                            hintText: 'Buscar por cédula o email',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      icon: Icon(
                        Icons.search,
                        color: Colors.blue.shade900,
                        size: 35,
                      ),
                      onPressed: () {
                        final searchQuery = searchController.text;
                        if (searchQuery.isEmpty) {
                          ref
                              .read(allUsersControllerProvider.notifier)
                              .loadUsers();
                          setState(() {
                            filteredUsers = users;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'El campo de busqueda no puede ser vacio .'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        _filterUsers(searchQuery);
                      },
                    ),
                  ],
                ),
              ),
            ),
            ButtonRectangular(
                      color: Colors.blue,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                          const Text(
                            'Crear usuario',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              ),
                          ),
                        ],
                      ),
                      onPressedFunction: () => goRouter.pushNamed('adminCreateUser'),
                    ),
            Expanded(
              child: users.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return UserListItem(
                          userEmail: user.email ?? '',
                          userName: user.name ?? '',
                          onDeleteTap: () =>
                              _onDeleteTap(context, user),
                          onEditTap: () =>
                              goRouter.pushNamed('adminEditUser', extra: user),
                        );
                      },
                    ),
            ),
                    ],
                  ),
          )),
    );
  }
}
