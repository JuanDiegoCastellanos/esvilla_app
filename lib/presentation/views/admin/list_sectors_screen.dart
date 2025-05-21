import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/presentation/providers/sectors/all_sector_provider.dart';
import 'package:esvilla_app/presentation/providers/sectors/delete_sector_provider.dart';
import 'package:esvilla_app/presentation/providers/sectors/list_all_sectors_provider.dart';
import 'package:esvilla_app/presentation/providers/sectors/sector_model_presentation.dart';
import 'package:esvilla_app/presentation/views/admin/admin_home_screen.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListSectorsScreen extends ConsumerWidget {
  const ListSectorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchSectorQuery = ref.watch(sectorSearchTextProvider);
    final dateSectorQuery = ref.watch(sectorDateFilterProvider);
    final sectorList = ref.watch(listSectorNotifierProvider);
    final goRouter = ref.watch(goRouterProvider);

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
                          ref.read(sectorSearchTextProvider.notifier).state = t,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                      decoration: const InputDecoration(
                        hintText: 'Buscar por nombre',
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
                    if (searchSectorQuery.isEmpty) {
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
                      onChanged: (text) async => {
                        if (text.isEmpty)
                          {
                            ref.read(sectorDateFilterProvider.notifier).state =
                                '',
                            await ref.read(listSectorNotifierProvider.notifier).load()
                          }
                        else
                          {
                            ref.read(sectorDateFilterProvider.notifier).state =
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
                    if (dateSectorQuery.isEmpty) {
                      await ref.read(listAllSectorsProvider.future);
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
                      final qDate = DateTime.parse(dateSectorQuery);
                      // --- Aquí creamos el rango completo del día:
                      final startOfDay =
                          DateTime(qDate.year, qDate.month, qDate.day);
                      // ignore: unused_local_variable
                      final endOfDay = startOfDay
                          .add(const Duration(days: 1))
                          .subtract(const Duration(milliseconds: 1));
                      ref
                          .read(listSectorNotifierProvider.notifier)
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
        Center(
            child: ButtonRectangular(
          size: WidgetStateProperty.all(const Size(200, 30)),
          color: Colors.blue,
          onPressedFunction: () {
            ref.read(goRouterProvider).pushNamed('adminCreateSector');
          },
          child: Text(
            'Crear Sector',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )),
        Expanded(
          child: sectorList.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Revisa tu conexion a internet'),
                  ),
                  ButtonRectangular(
                    size: WidgetStateProperty.all(const Size(150, 30)),
                    onPressedFunction: () {
                      ref.read(sectorSearchTextProvider.notifier).state = '';
                      ref.read(sectorDateFilterProvider.notifier).state = '';
                      ref.invalidate(listSectorNotifierProvider);
                    },
                    child: Text(
                      'Reintentar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            data: (sectorList) {
              //Filros
              final filtered = sectorList.where(
                (sector) {
                final sectorsMatch = searchSectorQuery.isEmpty ||
                    sector.name!.toLowerCase()== (searchSectorQuery.toLowerCase());
                return sectorsMatch;
              }).toList();

              if (filtered.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    // limpia filtros
                    ref.read(sectorSearchTextProvider.notifier).state = '';
                    ref.read(sectorDateFilterProvider.notifier).state = '';
                    ref.invalidate(listSectorNotifierProvider);
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 200),
                      Center(child: Text('No hay sectores que coincidan.')),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  // limpia filtros
                  ref.read(sectorSearchTextProvider.notifier).state = '';
                  ref.read(sectorDateFilterProvider.notifier).state = '';
                  // llama load
                  ref.invalidate(listSectorNotifierProvider);
                },
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    // Si llegamos al fondo, pedimos más
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200) {
                      //ref.invalidate(listScheduleNotifierProvider);
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
                      final sector = filtered[i];
                      return Card(
                        color: Colors.blue.shade100,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Sector: ${sector.name}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(height: 8),
                              Text(
                                  '${sector.description}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(height: 8),
                              Text(
                                'Fecha de creación: '
                                '${sector.createdAt != null ? sector.createdAt!.toIso8601String().split("T").first : ""}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Fecha de actualización: '
                                '${sector.updatedAt != null ? sector.updatedAt!.toIso8601String().split("T").first : ""}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 12),
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
                                        'adminEditSector',
                                        extra: sector),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    onPressed: () =>
                                        _onDeleteTap(context, sector, ref),
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

  void _onDeleteTap(BuildContext context,
      SectorModelPresentation sectorModel, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.blue.shade100,
                title: const Text('Eliminar sector'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        '¿Estás seguro de eliminar este sector?'),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.lightBlue.shade300,
                        child: Text(sectorModel.name?[0] ?? ''),
                      ),
                      title: Text(sectorModel.name ?? ''),
                      subtitle: Text(
                        sectorModel.description ?? '',
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
                      Navigator.of(context).pop();
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
                      await ref.read(deleteSectorProvider(sectorModel).future);
                      await ref.read(listSectorNotifierProvider.notifier).load();
                    },
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]));
  }
}
