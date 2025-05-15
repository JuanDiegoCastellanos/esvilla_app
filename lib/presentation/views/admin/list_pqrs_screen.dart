import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/presentation/providers/pqrs/all_pqrs_provider.dart';
import 'package:esvilla_app/presentation/providers/pqrs/pqrs_model_presentation.dart';
import 'package:esvilla_app/presentation/views/admin/admin_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListPqrsScreen extends ConsumerWidget {
  const ListPqrsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listPqrsAsync = ref.watch(listPqrsNotifierProvider);
    final searchQueryPqrs = ref.watch(pqrsSearchTextProvider);
    final dateQueryPqrs = ref.watch(pqrsDateFilterProvider);
    final goRouter = ref.read(goRouterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE4F7FF),
      body: SafeArea(
          child: Column(children: [
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
                      onChanged: (t) =>
                          ref.read(pqrsSearchTextProvider.notifier).state = t,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                      decoration: const InputDecoration(
                        hintText: 'Buscar por titulo',
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
                    size: 30,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (searchQueryPqrs.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('El campo de busqueda no puede ser vacio .'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
            height: 70,
            width: double.infinity,
            color: const Color.fromRGBO(47, 39, 125, 1),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text(
                    'Buscar por fecha',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      keyboardType: TextInputType.datetime,
                      onChanged: (text)async => {
                        if (text.isEmpty)
                          {
                            ref.read(pqrsDateFilterProvider.notifier).state =
                                '',
                            await ref.read(listPqrsNotifierProvider.notifier).load()
                          }
                        else
                          {
                            ref.read(pqrsDateFilterProvider.notifier).state =
                                text,
                          }
                      },
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      decoration: const InputDecoration(
                        hintText: '(yyyy-mm-dd)',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
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
                    size: 30,
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (dateQueryPqrs.isEmpty) {
                      await ref.read(listPqrsNotifierProvider.notifier).load();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('El campo de busqueda no puede ser vacio .'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    try {
                      final qDate = DateTime.parse(dateQueryPqrs);
                      // --- Aquí creamos el rango completo del día:
                      final startOfDay =
                          DateTime(qDate.year, qDate.month, qDate.day);
                      // ignore: unused_local_variable
                      final endOfDay = startOfDay
                          .add(const Duration(days: 1))
                          .subtract(const Duration(milliseconds: 1));
                      ref
                          .read(listPqrsNotifierProvider.notifier)
                          .filterByDate(qDate);
                    } catch (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Formato de fecha inválido. Usa yyyy-MM-dd.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: listPqrsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text(e.toString())),
            data: (pqrsList) {
              //Filros
              final filtered = pqrsList.where((pqrs) {
                final matchText = searchQueryPqrs.isEmpty ||
                    (pqrs.subject!.toLowerCase().contains(searchQueryPqrs));
                return matchText;
              }).toList();

              if (filtered.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    // limpia filtros
                    ref.read(pqrsSearchTextProvider.notifier).state = '';
                    ref.read(pqrsDateFilterProvider.notifier).state = '';
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 200),
                      Center(child: Text('No hay PQRS que coincidan.')),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  // limpia filtros
                  ref.read(pqrsSearchTextProvider.notifier).state = '';
                  ref.read(pqrsDateFilterProvider.notifier).state = '';
                  // llama load
                  ref.invalidate(listPqrsNotifierProvider);
                },
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    // Si llegamos al fondo, pedimos más
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200) {
                      //ref.invalidate(listPqrsNotifierProvider);
                    }
                    return false;
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      if (i == filtered.length) {
                        // indicador de “cargando siguiente página”
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final pqrs = filtered[i];
                      return Card(
                        color: Colors.blue.shade100,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pqrs.subject ?? '',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(
                                pqrs.radicadorName ?? '',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Fecha de creación: '
                                '${pqrs.createdAt != null ? pqrs.createdAt!.toIso8601String().split("T").first : ""}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Fecha de actualización: '
                                '${pqrs.updatedAt != null ? pqrs.updatedAt!.toIso8601String().split("T").first : ""}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                    onPressed: () => goRouter.pushNamed(
                                        'adminEditPqrs',
                                        extra: pqrs),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    onPressed: () =>
                                        _onDeleteTap(context, pqrs, ref),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        )
      ])),
    );
  }

  void _onDeleteTap(
      BuildContext context, PqrsModelPresentation pqrsModel, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.blue.shade100,
                title: const Text('Eliminar anuncio o noticia'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        '¿Estás seguro de eliminar este anuncio o noticia?'),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.lightBlue.shade300,
                        child: Text(pqrsModel.subject?[0] ?? ''),
                      ),
                      title: Text(pqrsModel.radicadorName ?? ''),
                      subtitle: Text(
                        pqrsModel.createdAt?.toIso8601String() ?? '',
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
                    onPressed: () async {
                      ref.read(goRouterProvider).pop();
                      await ref.read(deletePqrsProvider(pqrsModel).future);
                      await ref.read(listPqrsNotifierProvider.notifier).load();
                    },
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]));
  }
}
