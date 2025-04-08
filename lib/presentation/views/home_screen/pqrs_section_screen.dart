import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _asuntoController = TextEditingController();
  final _descripcionController = TextEditingController();

  final int _maxDescripcionLength = 1000;

  @override
  void dispose() {
    _asuntoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  String? _validarCampo(String? value, String nombreCampo) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa $nombreCampo';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userHasPQRS = false;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: userHasPQRS
          ? buildPQRSStatusInfo(context, ref, 'PQRS 1234',
              '2023-06-01 10:00:00', 'Pendiente', _validarCampo)
          : buildPQRSForm(context, ref, _formKey, _asuntoController,
              _descripcionController, _validarCampo, _maxDescripcionLength),
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
  int maxDescripcionLength,
) {
  return Form(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PQRS - Soporte esvilla',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w400,
              color: Colors.blue.shade900),
        ),
        const SizedBox(height: 10),
        // Texto descriptivo
        const Text(
          'Estimado usuario le recordamos que si ya ha generado una PQRS '
          'debe esperar a que esta sea solucionada para generar una nueva.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        // Campo: Asunto
        TextFieldFormEsvilla(
          name: 'ASUNTO:',
          controller: asuntoController,
          inputType: TextInputType.text,
          validator: (value) => validarCampo(value, 'el asunto'),
        ),
        const SizedBox(height: 16),
        // Campo: Descripción
        // Si realmente necesitas contar “palabras”, deberías separar por espacios.
        // Aquí contamos caracteres para simplificar.
        TextFormField(
          controller: descripcionController,
          maxLines: 10,
          // maxLength: _maxDescripcionLength, // O puedes usar un contador manual
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxDescripcionLength),
          ],
          decoration: InputDecoration(
            labelText: 'DESCRIPCIÓN:',
            floatingLabelStyle: TextStyle(
              color: Colors.blue.shade900,
              fontSize: 22,
            ),
            alignLabelWithHint: true,
            labelStyle: const TextStyle(fontWeight: FontWeight.w400),
            filled: true,
            fillColor: Colors.white,
            helperText: 'Max 1000 caracteres',
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maxLength: 2000,
          validator: (value) => validarCampo(value, 'la descripción'),
        ),
        // Contador manual de caracteres
        const SizedBox(height: 32),
        // Botón: Generar nuevo PQRS
        SizedBox(
          width: double.infinity,
          child: ButtonRectangular(
            onPressedFunction: () {
              if (formKey.currentState!.validate()) {
                // Lógica para generar la nueva PQRS
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nueva PQRS generada'),
                  ),
                );
              }
            },
            child: const Text(
              'Generar nuevo PQRS',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildPQRSStatusInfo(BuildContext context, WidgetRef ref, String asunto,
    dynamic fecha, String estado, Function validarCampo) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'PQRS - Soporte esvilla',
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: Colors.blue.shade900),
      ),
      const SizedBox(height: 10),
      // Texto descriptivo
      const Text(
        'Estimado usuario le recordamos que si ya ha generado una PQRS '
        'debe esperar a que esta sea solucionada para generar una nueva.',
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 24),

      // Campo: ASUNTO (solo muestra información, no editable)
      TextFormField(
        initialValue: asunto,
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
        initialValue: fecha,
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Estado: En progreso',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),

      // Container con el mensaje de estado
      Container(
        width: double.infinity,
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          '',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ],
  );
}
