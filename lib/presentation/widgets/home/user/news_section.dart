import 'dart:convert';
import 'dart:typed_data';

import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/presentation/providers/announcements/announcements_list_state_notifier_provider.dart';
import 'package:esvilla_app/presentation/providers/announcements/dropdown_selected_item_provider.dart';
import 'package:esvilla_app/presentation/providers/user/get_user_by_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsSection extends ConsumerWidget {
  const NewsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsListState =
        ref.watch(announcementsListControllerProvider);

    return Column(children: [
      _buildFilterSection(context, ref),
      announcementsListState.when(
        data: (paginatedResponse) {
          if (paginatedResponse.data.isEmpty) {
            return const Center(
              child: Text('No hay noticias disponibles.'),
            );
          }
          return Column(
            children: [
              ...paginatedResponse.data
                  .map((item) => _buildNewsItem(context, item, ref)),
              if (paginatedResponse.meta.hasNextPage) ...[
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref
                      .read(announcementsListControllerProvider.notifier)
                      .clearFilters(),
                  child: const Text(
                    'Ver más',
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ]
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error al cargar noticias: $error'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextButton(
          onPressed: () {
            ref
                .read(announcementsListControllerProvider.notifier)
                .loadMoreNews();
          },
          child: Text(
            'Ver más',
            style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 18,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue.shade800),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          alignment: Alignment.centerRight,
          child: FloatingActionButton(
            backgroundColor: Colors.blue.shade500,
            onPressed: () {
              ref
                  .read(announcementsListControllerProvider.notifier)
                  .loadInitialNews();
            },
            child: const Icon(
              Icons.restore,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ]);
  }
}

Widget _buildFilterSection(BuildContext context, WidgetRef ref) {
  final selectedDropdownItem = ref.watch(dropdownSelectedItemProvider);
  final sortOrder = ref.watch(sortOrderProvider);

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        // Ordenación
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ordenar por: ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue.shade800,
              ),
            ),
            DropdownButton<String>(
              alignment: AlignmentDirectional.bottomCenter,
              dropdownColor: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
              iconSize: 30,
              iconEnabledColor: Colors.blue.shade900,
              padding: EdgeInsets.zero,
              underline: Container(),
              value: selectedDropdownItem.isEmpty
                  ? 'createdAt'
                  : selectedDropdownItem,
              onChanged: (value) {
                if (value != null) {
                  ref.read(dropdownSelectedItemProvider.notifier).state = value;
                  ref
                      .read(announcementsListControllerProvider.notifier)
                      .setSortBy(value, 'desc');
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'createdAt',
                  child: Text(
                    'Fecha',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 18,
                    ),
                  ),
                ),
                DropdownMenuItem(
                    value: 'title',
                    child: Text(
                      'Título',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 18,
                      ),
                    )),
              ],
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: sortOrder
                  ? Icon(
                      Icons.sort,
                      color: Colors.blue.shade900,
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.14159), // Reflect the icon
                      child: Icon(
                        Icons.sort,
                        color: Colors.blue.shade900,
                      ),
                    ),
              onPressed: () {
                // Toggle sort order
                ref.read(sortOrderProvider.notifier).state = !sortOrder;
                final order = sortOrder ? 'desc' : 'asc';
                final controller =
                    ref.read(announcementsListControllerProvider.notifier);
                controller.setSortBy(selectedDropdownItem,
                    order); // Simplificado para el ejemplo
              },
            ),
          ],
        ),

        // Filtro de fechas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Icon(
                Icons.calendar_today,
                color: Colors.blue.shade900,
              ),
              label: Text(
                'Filtrar por fecha',
                style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue.shade800),
              ),
              onPressed: () async {
                final DateTime now = DateTime.now();
                final DateTime defaultStart = now.subtract(Duration(days: 7));
                final DateTime defaultEnd = now;

                DateTime rawStart =
                    ref.read(dateProvider)['startDate'] ?? defaultStart;
                DateTime rawEnd =
                    ref.read(dateProvider)['endDate'] ?? defaultEnd;

                // Garantizar que start ≤ end:
                final DateTimeRange initialRange = rawStart.isAfter(rawEnd)
                    ? DateTimeRange(start: rawEnd, end: rawEnd)
                    : DateTimeRange(start: rawStart, end: rawEnd);

                final DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: now,
                  initialDateRange: initialRange,
                );

                if (picked != null) {
                  // Establecer startDate al inicio del día (00:00:00.000)
                  final startDate = DateTime(
                    picked.start.year,
                    picked.start.month,
                    picked.start.day,
                  );

                  // Establecer endDate al final del día (23:59:59.999)
                  final endDate = DateTime(
                    picked.end.year,
                    picked.end.month,
                    picked.end.day,
                    23,
                    59,
                    59,
                    999,
                  );

                  AppLogger.i('Date range: $startDate to $endDate');

                  ref.read(dateProvider.notifier).state = {
                    'startDate': startDate,
                    'endDate': endDate,
                  };
                  final controller =
                      ref.read(announcementsListControllerProvider.notifier);
                  controller.setDateFilter(startDate, endDate);
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.clear, color: Colors.red.shade700),
              tooltip: 'Limpiar filtro de fecha',
              onPressed: () {
                final controller =
                    ref.read(announcementsListControllerProvider.notifier);
                controller.clearFilters();
                ref.read(dateProvider.notifier).state = {};
              },
            ),
          ],
        ),
      ],
    ),
  );
}

Uint8List decodeBase64Image(String data) {
  // Si viene con "data:image/…;base64,", lo quitamos:
  final regex = RegExp(r'data:image/[^;]+;base64,');
  final base64Str = data.replaceAll(regex, '');
  return Base64Decoder().convert(base64Str);
}

Widget _buildNewsItem(
    BuildContext context, AnnouncementsEntity item, WidgetRef ref) {
  // Decodifica la cadena Base64 a Uint8List (bytes)
  Uint8List? mainImageBytes;
  bool hasImage = false;
  if (item.mainImage != null && item.mainImage!.isNotEmpty) {
    try {
      mainImageBytes = decodeBase64Image(item.mainImage!);
      hasImage = true;
    } catch (e) {
      debugPrint('Error decodificando mainImage: $e');
    }
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    child: GestureDetector(
      onTap: () {
        // Mostrar el DraggableScrollableSheet como en tu código original
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          isDismissible: true,
          enableDrag: true,
          clipBehavior: Clip.hardEdge,
          barrierColor: Colors.black.withValues(alpha: 0.5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return _buildNewsDetailSheet(context, item, ref);
          },
        );
      },
      child: Card(
        color: Colors.blue.shade100,
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              if (hasImage)
                Image.memory(
                  mainImageBytes ?? Uint8List(0),
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                )
              else
                const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildNewsDetailSheet(
    BuildContext context, AnnouncementsEntity item, WidgetRef ref) {
  Uint8List? mainImageBytes;
  bool hasMainImage = false;
  if (item.mainImage != null && item.mainImage!.isNotEmpty) {
    try {
      mainImageBytes = decodeBase64Image(item.mainImage!);
      hasMainImage = true;
    } catch (e) {
      debugPrint('Error decodificando mainImage: $e');
    }
  }

  Uint8List? secondaryImageBytes;
  bool hasSecondaryImage = false;
  if (item.secondaryImage != null && item.secondaryImage!.isNotEmpty) {
    try {
      secondaryImageBytes = decodeBase64Image(item.secondaryImage!);
      hasSecondaryImage = true;
    } catch (e) {
      debugPrint('Error decodificando secondaryImage: $e');
    }
  }
  final userAsync = ref.watch(getUserByIdProvider(item.createdBy));
  return DraggableScrollableSheet(
    initialChildSize: 0.5,
    minChildSize: 0.4,
    maxChildSize: 0.95,
    expand: false,
    builder: (context, scrollController) {
      return GestureDetector(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800),
                      ),
                    ),
                    Text(
                      'Fecha: ${item.createdAt.year}-${item.createdAt.month}-${item.createdAt.day} ${item.createdAt.hour}:${item.createdAt.minute}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    userAsync.when(
                      data: (user) => Text(
                        'Creado por: ${user?.name ?? item.createdBy}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      loading: () => const Text(
                        'Cargando información del autor...',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      error: (error, stack) => Text(
                        'Creado por: ${item.createdBy}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (hasMainImage)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            mainImageBytes!,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.error,
                                color: Colors.red,
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Contenido detallado de la noticia
                    Text(
                      item.description,
                      style: TextStyle(fontSize: 20),
                    ),
                    if (hasSecondaryImage)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            secondaryImageBytes!,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.error,
                                color: Colors.red,
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      item.body,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
