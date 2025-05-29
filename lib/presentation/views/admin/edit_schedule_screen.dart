import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/presentation/providers/schedules/all_schedules_provider.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedule_model_presentation.dart';
import 'package:esvilla_app/presentation/providers/sectors/list_all_sectors_provider.dart';
import 'package:esvilla_app/presentation/providers/sectors/sector_model_presentation.dart';
import 'package:esvilla_app/presentation/views/admin/admin_home_screen.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:esvilla_app/presentation/widgets/shared/title_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditScheduleScreen extends ConsumerWidget {
  final dynamic schedule;
  final _formKey = GlobalKey<FormState>();
  EditScheduleScreen({super.key, required this.schedule});

  Future<void> _onSave(WidgetRef ref, BuildContext context) async {
    // 1. Validar formulario
    if (!_formKey.currentState!.validate()) return;

    // 2. Leer valores de los controllers y providers
    final observations =
        ref.read(observationsTypeControllerProvider(schedule)).text.trim();
    final trashType =
        ref.read(trashTypeControllerProvider(schedule)).text.trim();
    final startTime =
        ref.read(startTimeControllerProvider(schedule)).text.trim();

    final endTime = ref.read(endTimeControllerProvider(schedule)).text.trim();
    final isActive = ref.read(stateScheduleProvider(schedule).notifier).state;
    final days = ref.read(selectedDaysProvider(schedule.days));

    final selectedNames = ref.read(selectedSectorsListProvider(schedule));
    final all = ref.read(listAllSectorsProvider).maybeWhen(
          data: (list) => list,
          orElse: () => <SectorModelPresentation>[],
        );
    final selectedFilteredIds = all
        .where((s) => selectedNames.contains(s.name))
        .map((s) => s.id!)
        .toList();

    final updatedScheduleModel = ScheduleModelPresentation(
      id: schedule.id!,
      observations: observations,
      garbageType: trashType,
      startTime: startTime,
      endTime: endTime,
      active: isActive,
      days: days,
      associatedSectors: selectedFilteredIds,
    );

    try {
      final success =
          await ref.read(updateScheduleProvider(updatedScheduleModel).future);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Actualizado!',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
            backgroundColor: Colors.green,
            duration: const Duration(milliseconds: 500),
          ),
        );
        ref.read(goRouterProvider).pop();
        ref.invalidate(listScheduleNotifierProvider);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hubo cambios.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
            backgroundColor: Colors.grey,
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    } on AppException catch (e) {
      // Manejo de errores HTTP / validaciones
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDays = ref.watch(selectedDaysProvider(schedule.days));
    final trashTypeController =
        ref.watch(trashTypeControllerProvider(schedule));
    final observationsController =
        ref.watch(observationsTypeControllerProvider(schedule));
    final startTimeController =
        ref.watch(startTimeControllerProvider(schedule));
    //final endTimeController = ref.watch(endTimeControllerProvider(schedule));

    final searchSectorController = ref.watch(searchSectorControllerProvider);

    final stateSchedule = ref.watch(stateScheduleProvider(schedule));

    final sectorsList = ref.watch(listAllSectorsProvider);

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const EsvillaAppBar(),
              const SizedBox(height: 12),
              TitleSection(titleText: 'Edición de Horario'),
              const SizedBox(height: 16),
              ExpansionTile(
                backgroundColor: Colors.blue.shade100,
                collapsedBackgroundColor: Colors.blue.shade50,
                collapsedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                title: Text(
                  'Selecciona los días',
                  style: TextStyle(color: Colors.blue.shade900, fontSize: 20),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Wrap(
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
                            final notifier = ref.read(
                                selectedDaysProvider(schedule.days).notifier);
                            if (sel) {
                              notifier.state = [...notifier.state, day];
                            } else {
                              notifier.state = [...notifier.state..remove(day)];
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFieldFormEsvilla(
                name: 'Observaciones',
                maxLength: 100,
                controller: observationsController,
                inputType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Las observaciones son requeridas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFieldFormEsvilla(
                name: 'Tipo de Basura',
                maxLength: 60,
                controller: trashTypeController,
                inputType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Las observaciones son requeridas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Hora Inicio',
                        floatingLabelStyle:
                            const TextStyle(color: Colors.blue, fontSize: 22),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 4,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                        ),
                      ),
                      maxLength: 7,
                      keyboardType: TextInputType.datetime,
                      controller: startTimeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La hora de inicio es requerida';
                        }

                        final timeRegex =
                            RegExp(r'^([1-9]|1[0-2]):[0-5][0-9] (AM|PM)$');
                        if (!timeRegex.hasMatch(value)) {
                          return 'Formato inválido. Use: HH:MM AM/PM';
                        }

                        return null;
                      },
                      onTap: () async {
                        TimeOfDay initialTime = TimeOfDay.now();

                        if (startTimeController.text.isNotEmpty) {
                          initialTime = parseTime(startTimeController.text);
                        }

                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: initialTime,
                          builder: (context, child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: false),
                              child: child!,
                            );
                          },
                        );

                        if (pickedTime != null) {
                          final hour = pickedTime.hourOfPeriod; // 1-12
                          final minute =
                              pickedTime.minute.toString().padLeft(2, '0');
                          final period =
                              pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
                          startTimeController.text = '$hour:$minute $period';
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilterChip(
                label: Text(
                  'Estado: ${stateSchedule ? 'Activo' : 'Inactivo'}',
                  style: TextStyle(
                      color: stateSchedule
                          ? Colors.white
                          : Colors.blueGrey.shade700),
                ),
                backgroundColor: Colors.blue.shade100,
                selectedColor: Colors.green,
                selected: stateSchedule,
                onSelected: (value) {
                  ref.read(stateScheduleProvider(schedule).notifier).state =
                      value;
                },
              ),
              const SizedBox(height: 16),
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
                title: Text(
                  'Asigna sectores',
                  style: TextStyle(color: Colors.blue.shade900, fontSize: 20),
                ),
                children: [
                  SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      maxLength: 60,
                      minLines: 1,
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      controller: searchSectorController,
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
                            searchSectorController.text = '';
                            ref.read(searchSectorProvider.notifier).state = '';
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (searchSectorController.text.isNotEmpty) {
                              ref.read(searchSectorProvider.notifier).state =
                                  searchSectorController.text.trim();
                              ref.invalidate(listAllSectorsProvider);
                            } else {
                              ref.read(searchSectorProvider.notifier).state =
                                  '';
                              ref.invalidate(listAllSectorsProvider);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.blue)),
                          child: Text(
                            'Buscar',
                            style: TextStyle(color: Colors.white),
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await ref
                              .read(goRouterProvider)
                              .pushNamed('adminCreateSector');
                          ref.invalidate(listAllSectorsProvider);
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Colors.deepPurple.shade100)),
                        child: Text(
                          'Crear sector',
                          style: TextStyle(color: Colors.deepPurple.shade800),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  sectorsList.when(
                    error: (_, __) => Text('Ocurrio un error inesperado...'),
                    loading: () => CircularProgressIndicator(),
                    data: (allSectors) {
                      final query =
                          ref.watch(searchSectorProvider).toLowerCase();
                      final filtered = query.isEmpty
                          ? allSectors
                          : allSectors
                              .where((s) =>
                                  (s.name ?? '').toLowerCase().contains(query))
                              .toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final sector = filtered[index];
                          final selectedNames =
                              ref.watch(selectedSectorsListProvider(schedule));
                          final selected = selectedNames.contains(sector.name);

                          return CheckboxListTile(
                            title: Text(sector.name ?? ''),
                            value: selected,
                            checkColor: Colors.white,
                            activeColor: Colors.red,
                            onChanged: (checked) {
                              final notifier = ref.read(
                                  selectedSectorsListProvider(schedule)
                                      .notifier);
                              if (checked == true) {
                                notifier.state = [
                                  ...notifier.state,
                                  sector.name!
                                ];
                              } else {
                                notifier.state = notifier.state
                                    .where((n) => n != sector.name)
                                    .toList();
                              }
                            },
                          );
                        },
                      );
                    },
                  )
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final dias =
                          ref.read(selectedDaysProvider(schedule.days));
                      if (dias.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Debes seleccionar al menos un día'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      } else {
                        if (!_formKey.currentState!.validate()) return;
                        await _onSave(ref, context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  TimeOfDay parseTime(String timeString) {
    try {
      final parts = timeString.split(' ');
      final time = parts[0].split(':');
      int hour = int.parse(time[0]);
      final int minute = int.parse(time[1]);
      final String period = parts.length > 1 ? parts[1] : 'AM';

      // Convertir a 24h
      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now(); // Fallback
    }
  }
}
