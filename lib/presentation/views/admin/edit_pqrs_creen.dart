import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/presentation/providers/pqrs/all_pqrs_provider.dart';
import 'package:esvilla_app/presentation/providers/pqrs/pqrs_model_presentation.dart';
import 'package:esvilla_app/presentation/views/admin/admin_home_screen.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:esvilla_app/presentation/widgets/shared/title_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPqrsScreen extends ConsumerWidget {
  final dynamic pqrs;
  final _formKey = GlobalKey<FormState>();
  EditPqrsScreen({super.key, required this.pqrs});

  void update(WidgetRef ref, BuildContext context, PqrsStatusEnum state, String resolutionText) async {
    if (_formKey.currentState!.validate()) {

      final pqrsModel = PqrsModelPresentation(
        id: (pqrs as PqrsModelPresentation).id,
        subject: (pqrs as PqrsModelPresentation).subject,
        description: (pqrs as PqrsModelPresentation).description,
        status: state,
        resolution: resolutionText,
      );
      final success = await ref.read(updatePqrsProvider(pqrsModel).future);

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
    }
  }

  Color _getColorStatus(PqrsStatusEnum status) {
    switch (status) {
      case PqrsStatusEnum.pendiente:
        return Colors.blueGrey;
      case PqrsStatusEnum.EnProceso:
        return Colors.blue.shade900;
      case PqrsStatusEnum.cerrado:
        return Colors.brown;
      case PqrsStatusEnum.cancelado:
        return Color(0xFFFF0F0F);
      case PqrsStatusEnum.solucionado:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl   = ref.watch(resolutionControllerProvider(pqrs));
    final status = ref.watch(statusProvider(pqrs));
    return Scaffold(
      backgroundColor: const Color(0xFFE4F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const EsvillaAppBar(),
                const SizedBox(height: 12),
                TitleSection(titleText: 'Gestión de PQRS'),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Radicador: ${(pqrs as PqrsModelPresentation).radicadorName}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Asunto: ${(pqrs as PqrsModelPresentation).subject}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Fecha: ${(pqrs as PqrsModelPresentation).updatedAt}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        'Estado:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getColorStatus(status),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  '¿A que estado quieres cambiar el PQRS actual?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 50),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  runSpacing: 16,
                  spacing: 16,
                  children: [
                    ButtonRectangular(
                      size: WidgetStatePropertyAll(const Size(160, 50)),
                      color: Colors.green,
                      onPressedFunction: () => ref
                          .read(statusProvider(pqrs).notifier)
                          .state = PqrsStatusEnum.solucionado,
                      child: Text(
                        'Solucionado',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ButtonRectangular(
                      size: WidgetStatePropertyAll(const Size(160, 50)),
                      color: Colors.blue.shade900,
                      onPressedFunction: () => ref
                          .read(statusProvider(pqrs).notifier)
                          .state = PqrsStatusEnum.EnProceso,
                      child: Text(
                        'En proceso',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ButtonRectangular(
                      size: WidgetStatePropertyAll(const Size(160, 50)),
                      color: Colors.brown,
                      onPressedFunction: () => ref
                          .read(statusProvider(pqrs).notifier)
                          .state = PqrsStatusEnum.cerrado,
                      child: Text(
                        'Cerrado',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ButtonRectangular(
                      size: WidgetStatePropertyAll(const Size(160, 50)),
                      color: Colors.blueGrey,
                      onPressedFunction: () => ref
                          .read(statusProvider(pqrs).notifier)
                          .state = PqrsStatusEnum.pendiente,
                      child: Text(
                        'Pendiente',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ButtonRectangular(
                      size: WidgetStatePropertyAll(const Size(160, 50)),
                      color: Color(0xFFFF0F0F),
                      onPressedFunction: () =>_onDeleteTap(context, pqrs, ref),
                      child: Text(
                        'Cancelado',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Resolución o detalles del estado:',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    )),
                TextFieldFormEsvilla(
                  name: '',
                  controller: ctrl,
                  inputType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La resolución o detalles del estado es requerido';
                    }
                    if (value.length > 1000) {
                      return 'La resolución o detalles del estado debe tener un máximo de 1000 caracteres';
                    }
                    return null;
                  },
                  maxLength: 1000,
                  maxLines: 8,
                  minLines: 4,
                ),
                SizedBox(
                  height: 20,
                ),
                ButtonRectangular(
                  size: WidgetStatePropertyAll(const Size(260, 50)),
                  color: Colors.green,
                  onPressedFunction: () => update(ref, context, status, ctrl.text),
                  child: Text(
                    'Guardar cambios',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
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
                title: const Text('Cancelar anuncio o noticia'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        '¿Estás seguro de cancelar este anuncio o noticia?. No puede recuperarse después de ser eliminada.'),
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
                      ref
                          .read(statusProvider(pqrs).notifier)
                          .state = PqrsStatusEnum.cancelado;
                      await ref.read(deletePqrsProvider(pqrsModel).future);
                      ref.read(goRouterProvider).pop();
                      ref.read(goRouterProvider).pop();
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
