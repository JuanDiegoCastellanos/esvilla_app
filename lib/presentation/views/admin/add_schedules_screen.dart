import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/presentation/providers/schedules/all_schedules_provider.dart';
import 'package:esvilla_app/presentation/providers/schedules/create_schedule_providers.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedule_model_presentation.dart';
import 'package:esvilla_app/presentation/providers/sectors/list_all_sectors_provider.dart';
import 'package:esvilla_app/presentation/providers/sectors/sector_model_presentation.dart';
import 'package:esvilla_app/presentation/views/admin/admin_home_screen.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:esvilla_app/presentation/widgets/shared/title_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSchedulesScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  AddSchedulesScreen({super.key});

  Future<void> _onSave(WidgetRef ref, BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    // 1) Leemos los valores de los controllers y providers
    final observations =
        ref.read(observationsCreateControllerProvider).text.trim();
    final trashType = ref.read(trashTypeCreateControllerProvider).text.trim();
    final startTime = ref.read(startTimeCreateControllerProvider).text.trim();
    final endTime = ref.read(endTimeCreateControllerProvider).text.trim();
    final isActive = ref.read(stateScheduleCreateProvider.notifier).state;
    final days = ref.read(selectedDaysCreateProvider);

    final selectedNames = ref.read(selectedSectorsListCreateProvider);

    final all = ref.read(listAllSectorsProvider).maybeWhen(
          data: (list) => list,
          orElse: () => <SectorModelPresentation>[],
        );
    final selectedIds = all
        .where((s) => selectedNames.contains(s.name))
        .map((s) => s.id!)
        .toList();

    // 2) Construimos el modelo y llamamos al provider de creación
    final newSchedule = ScheduleModelPresentation(
      observations: observations,
      garbageType: trashType,
      startTime: startTime,
      endTime: endTime,
      active: isActive,
      days: days,
      associatedSectors: selectedIds,
    );

    try {
      final success =
          await ref.read(createScheduleProvider(newSchedule).future);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('¡Creado satisfactoriamente!', textAlign: TextAlign.center),
          backgroundColor: Colors.green,
        ));
        // Regresamos y forzamos recarga de la lista
        ref.read(goRouterProvider).pop(true);
        ref.invalidate(listScheduleNotifierProvider);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No se pudo crear.'),
          backgroundColor: Colors.grey,
        ));
      }
    } on AppException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.message}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDays = ref.watch(selectedDaysCreateProvider);
    final observationsCtrl = ref.watch(observationsCreateControllerProvider);
    final trashTypeCtrl = ref.watch(trashTypeCreateControllerProvider);
    final startTimeCtrl = ref.watch(startTimeCreateControllerProvider);
    final endTimeCtrl = ref.watch(endTimeCreateControllerProvider);
    final isActive = ref.watch(stateScheduleCreateProvider);
    final searchSectorCtrl = ref.watch(searchSectorCreateControllerProvider);
    final sectorsList = ref.watch(listAllSectorsProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(children: [
              const EsvillaAppBar(),
              const SizedBox(height: 12),
              TitleSection(titleText: 'Crear Horario'),
              const SizedBox(height: 16),

              // DÍAS
              ExpansionTile(
                backgroundColor: Colors.blue.shade100,
                collapsedBackgroundColor: Colors.blue.shade50,
                collapsedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                title: const Text('Selecciona los días'),
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 2,
                    children: weekDays.map((day) {
                      final isSelected = selectedDays.contains(day);
                      return FilterChip(
                        backgroundColor: Colors.blue.shade50,
                        side: BorderSide(color: Colors.blue.shade200),
                        selectedColor: Colors.red,
                        checkmarkColor: Colors.white,
                        label: Text(
                          day,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (sel) {
                          final notifier =
                              ref.read(selectedDaysCreateProvider.notifier);
                          if (sel) {
                            notifier.state = [...notifier.state, day];
                          } else {
                            notifier.state = [...notifier.state..remove(day)];
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // OBSERVACIONES
              TextFieldFormEsvilla(
                name: 'Observaciones',
                inputType: TextInputType.multiline,
                maxLines: 3,
                minLines: 1,
                maxLength: 80,
                controller: observationsCtrl,
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              // TIPO BASURA
              TextFieldFormEsvilla(
                name: 'Tipo de Basura',
                inputType: TextInputType.text,
                maxLength: 50,
                minLines: 1,
                maxLines: 1,
                controller: trashTypeCtrl,
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              // HORARIOS
              Row(children: [
                Expanded(
                  child: TextFieldFormEsvilla(
                    name: 'Hora Inicio',
                    maxLength: 5,
                    minLength: 5,
                    inputType: TextInputType.datetime,
                    controller: startTimeCtrl,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 5) {
                        return 'La hora de inicio es requerida';
                      }
                      final time = value.split(':');
                      if (time.length != 2) {
                        return 'La hora de inicio debe ser en formato HH:MM';
                      }
                      try {
                        final hour = int.parse(time[0]);
                        final minute = int.parse(time[1]);
                        if (hour < 0 ||
                            hour > 23 ||
                            minute < 0 ||
                            minute > 59) {
                          return 'La hora de inicio es inválida';
                        }
                      } on FormatException {
                        return 'La hora de inicio debe ser en formato HH:MM';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFieldFormEsvilla(
                    inputType: TextInputType.datetime,
                    maxLength: 5,
                    minLength: 5,
                    name: 'Hora Fin',
                    controller: endTimeCtrl,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 5) {
                        return 'La hora de fin es requerida';
                      }
                      final time = value.split(':');
                      if (time.length != 2) {
                        return 'La hora de fin debe ser en formato HH:MM';
                      }
                      try {
                        final hour = int.parse(time[0]);
                        final minute = int.parse(time[1]);
                        if (hour < 0 ||
                            hour > 23 ||
                            minute < 0 ||
                            minute > 59) {
                          return 'La hora de fin es inválida';
                        }
                      } on FormatException {
                        return 'La hora de fin debe ser en formato HH:MM';
                      }
                      return null;
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 16),

              // ESTADO
              FilterChip(
                label: Text(
                  isActive ? 'Activo' : 'Inactivo',
                  style: TextStyle(
                      color:
                          isActive ? Colors.white : Colors.blueGrey.shade700),
                ),
                backgroundColor: Colors.blue.shade100,
                selectedColor: Colors.green,
                selected: isActive,
                onSelected: (v) =>
                    ref.read(stateScheduleCreateProvider.notifier).state = v,
              ),
              const SizedBox(height: 16),

              // SECTORES
              ExpansionTile(
                backgroundColor: Colors.white,
                collapsedBackgroundColor: Colors.blue.shade50,
                collapsedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(color: Colors.blue, width: 1.5),
                ),
                title: const Text('Asigna sectores'),
                children: [
                  // buscador
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      maxLength: 60,
                      minLines: 1,
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      controller: searchSectorCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blue.shade800,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blue.shade800,
                            width: 4,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blue.shade800,
                            width: 1,
                          ),
                        ),
                        helperText: 'Buscar sector',
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.restore_page_outlined,
                            color: Colors.indigo.shade900,
                          ),
                          onPressed: () {
                            searchSectorCtrl.text = '';
                            ref.read(searchSectorCreateProvider.notifier).state = '';
                          },
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (searchSectorCtrl.text.isNotEmpty) {
                        ref.read(searchSectorCreateProvider.notifier).state =
                            searchSectorCtrl.text.trim();
                      } else {
                        ref.read(searchSectorCreateProvider.notifier).state = '';
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue)),
                    child: Text(
                      'Buscar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  sectorsList.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => const Text('Error al cargar sectores'),
                    data: (allSectors) {
                      final query = ref.watch(searchSectorCreateProvider).toLowerCase();
                      final filtered = query.isEmpty
                          ? allSectors
                          : allSectors
                              .where(
                                  (s) => s.name!.toLowerCase().contains(query))
                              .toList();

                      final selectedNames =
                          ref.watch(selectedSectorsListCreateProvider);

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) {
                          final sector = filtered[i];
                          final sel = selectedNames.contains(sector.name);
                          return CheckboxListTile(
                            title: Text(sector.name ?? ''),
                            value: sel,
                            checkColor: Colors.white,
                            activeColor: Colors.red,
                            onChanged: (v) {
                              final n = ref.read(
                                  selectedSectorsListCreateProvider.notifier);
                              if (v == true) {
                                n.state = [...n.state, sector.name!];
                              } else {
                                n.state = List.from(n.state)..remove(sector.name);
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => ref.read(goRouterProvider).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: () => _onSave(ref, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Guardar',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
