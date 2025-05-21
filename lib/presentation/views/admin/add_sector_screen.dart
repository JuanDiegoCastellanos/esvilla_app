import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/presentation/providers/sectors/all_sector_provider.dart';
import 'package:esvilla_app/presentation/providers/sectors/create_sector_providers.dart';
import 'package:esvilla_app/presentation/providers/sectors/sector_model_presentation.dart';
import 'package:esvilla_app/presentation/views/admin/admin_home_screen.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:esvilla_app/presentation/widgets/shared/title_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSectorScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  AddSectorScreen({super.key});

  Future<void> _onSave(WidgetRef ref, BuildContext context) async {
    final name = ref.read(nameControllerCreateProvider).text.trim();
    final description =
        ref.read(descriptionControllerCreateProvider).text.trim();

    final sectorModel = SectorModelPresentation(
      name: name,
      description: description,
      location: LocationModelPresentation(
        type: 'Polygon', //Se usa solo este, para agregar otro se debe cambiar directamente en el backend
        coordinates: [[[0.0], [0.0]]], // No esta incorporado lo de mapas pero puede serun feature a futuro
      ),
    );
    try {
      final isUpdated =
          await ref.read(createSectorProvider(sectorModel).future);
      if (isUpdated) {
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
        ref.invalidate(listSectorNotifierProvider);
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
    final nameController = ref.watch(nameControllerCreateProvider);
    final descriptionController = ref.watch(descriptionControllerCreateProvider);
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
                TitleSection(titleText: 'Creación de Horario'),
                const SizedBox(height: 12),
                TextFieldFormEsvilla(
                  name: 'Nombre del sector: ',
                  maxLength: 50,
                  controller: nameController,
                  inputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
                TextFieldFormEsvilla(
                  name: 'Descricpcion del sector: ',
                  maxLength: 100,
                  controller: descriptionController,
                  inputType: TextInputType.multiline,
                  maxLines: 3,
                  minLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descricpción es requerida';
                    }
                    return null;
                  },
                ),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    ButtonRectangular(
                        size: WidgetStateProperty.all(const Size(150, 50)),
                        color: Colors.green,
                        onPressedFunction: () async {
                          if (!_formKey.currentState!.validate()) return;
                          await _onSave(ref, context);
                        },
                        child: Text('Guardar',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20))),
                    ButtonRectangular(
                      size: WidgetStateProperty.all(const Size(150, 50)),
                      color: Colors.red,
                      onPressedFunction: () => ref.read(goRouterProvider).pop(),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}