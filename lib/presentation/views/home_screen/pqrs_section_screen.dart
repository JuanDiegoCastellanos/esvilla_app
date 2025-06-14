import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/data/mappers/pqrs/pqrs_mapper.dart';
import 'package:esvilla_app/presentation/providers/pqrs/generate_pqrs_controller_provider.dart';
import 'package:esvilla_app/presentation/providers/pqrs/get_my_pqrs_provider.dart';
import 'package:esvilla_app/presentation/providers/pqrs/pqrs_model_presentation.dart';
import 'package:esvilla_app/presentation/widgets/home/pqrs/status_dynamic_container.dart';
import 'package:esvilla_app/presentation/widgets/home/pqrs/text_form_field_pqrs.dart';
import 'package:esvilla_app/presentation/widgets/shared/title_section.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PqrsSectionScreen extends ConsumerStatefulWidget {
  const PqrsSectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PqrsSectionScreenState();
}

class _PqrsSectionScreenState extends ConsumerState<PqrsSectionScreen> {
  // Llave global para el Form
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validarCampo(String? value, String nombreCampo) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa $nombreCampo';
    }
    return null;
  }

  void _generateNewPqrs() async {
    final subject = _subjectController.text;
    final description = _descriptionController.text;

    if (subject.isEmpty || description.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor ingresa todos los campos'),
            backgroundColor: Colors.red),
      );
      return;
    }
    final createPqrsModel = PqrsModelPresentation(
      subject: subject,
      description: description,
    );

    // Llama al método del controlador
    try {
      final success = await ref
          .read(generatePqrsControllerProvider.notifier)
          .generatePqrs(createPqrsModel);

      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Tu PQRS ha sido radicado corrrectamente'),
              backgroundColor: Colors.green),
        );
        ref.read(getMyPqrsStateProvider.notifier).reload();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al radicar tu PQRS'),
              backgroundColor: Colors.red),
        );
      }
    } on AppException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: Duration(seconds: 5),
            content: Text(e.message),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pqrsAsyncValue = ref.watch(getMyPqrsStateProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: pqrsAsyncValue.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, stackTrace) => Center(
                child: Text('Error al cargar tu PQRS: ${error.toString()}'),
              ),
          data: (pqrsEntity) {
            final userHasPQRS = pqrsEntity != null;
            if (userHasPQRS) {
              final pqrs = PqrsMapper.toModel(pqrsEntity);
              return buildPQRSStatusInfo(
                  context,
                  ref,
                  pqrs.subject,
                  pqrs.getFormattedDate(pqrs.createdAt),
                  pqrs.status,
                  pqrs.resolucion ?? 'En revisión...',
                  _validarCampo);
            } else {
              return buildPQRSForm(context, ref, _formKey, _subjectController,
                  _descriptionController, _validarCampo, _generateNewPqrs);
            }
          } // cupertino activity indicator
          ),
    );
  }
}

Widget buildPQRSForm(
  BuildContext context,
  WidgetRef ref,
  GlobalKey<FormState> formKey,
  TextEditingController asuntoController,
  TextEditingController descripcionController,
  Function validarCampo,
  Function generatPqrsFunction,
) {
  return Form(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: TitleSection(titleText: 'PQRS - Soporte esvilla')),
        const SizedBox(height: 10),
        const Text(
          'Estimado usuario, en esta sección podrá crear y gestionar sus peticiones, quejas, reclamos y sugerencias (PQRS).',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        TextFieldFormEsvilla(
          name: 'ASUNTO:',
          maxLength: 50,
          minLength: 10,
          controller: asuntoController,
          inputType: TextInputType.text,
          validator: (value) => validarCampo(value, 'el ASUNTO'),
        ),
        const SizedBox(height: 16),
        TextFormFieldPqrs(
            controller: descripcionController,
            title: 'DESCRIPCIÓN:',
            helperText: 'Max 1000 caracteres',
            maxLines: 2000,
            isFilled: true,
            maxLength: 2000,
            validator: (value) => validarCampo(value, 'la DESCRIPCIÓN')),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ButtonRectangular(
            onPressedFunction: () {
              if (formKey.currentState!.validate()) {
                // Lógica para generar la nueva PQRS
                generatPqrsFunction();
              }
            },
            child: const Text(
              'Generar nuevo PQRS',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            alignment: Alignment.centerRight,
            child: FloatingActionButton(
              backgroundColor: Colors.blue.shade500,
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                ref.read(getMyPqrsStateProvider.notifier).reload();
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildPQRSStatusInfo(
    BuildContext context,
    WidgetRef ref,
    String subject,
    dynamic generatedDate,
    PqrsStatusEnum status,
    String statusMessage,
    Function fieldValidationFunction) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(child: TitleSection(titleText: 'PQRS - Soporte esvilla',)),
      const SizedBox(height: 10),
      // Texto descriptivo
      const Text(
        'Estimado usuario le recordamos que si ya ha generado una PQRS '
        'debe esperar a que esta sea solucionada para generar una nueva.',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
      ),
      const SizedBox(height: 24),

      // Campo: ASUNTO (solo muestra información, no editable)
      TextFormField(
        initialValue: subject,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'ASUNTO:',
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      const SizedBox(height: 16),

      // Campo: FECHA (solo muestra información, no editable)
      TextFormField(
        initialValue: generatedDate,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'FECHA:',
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          hintText: 'mm/dd/yyyy',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      const SizedBox(height: 16),

      // "Botón" de estado: un container decorativo con texto e ícono
      Center(
        child: StatusDynamicContainer(status: status),
      ),
      const SizedBox(height: 16),

      // Container con el mensaje de estado
      Container(
        width: double.infinity,
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          statusMessage,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          alignment: Alignment.centerRight,
          child: FloatingActionButton(
            backgroundColor: Colors.blue.shade500,
            child: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              ref.read(getMyPqrsStateProvider.notifier).reload();
            },
          ),
        ),
      ),
    ],
  );
}
