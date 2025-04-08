import 'package:esvilla_app/presentation/providers/user/user_controller_provider.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSectionScreen extends ConsumerStatefulWidget {
  const ProfileSectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileSectionScreenState();
}

class _ProfileSectionScreenState extends ConsumerState<ProfileSectionScreen> {
  // Llave global para el Form
  final _formKey = GlobalKey<FormState>();

  // Controladores de los campos
  final _nombreController = TextEditingController();
  final _documentoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();

  // Campos para la sección de contraseña
  final _claveAntiguaController = TextEditingController();
  final _nuevaClaveController = TextEditingController();
  final _repetirClaveController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Liberar los controladores
    _nombreController.dispose();
    _documentoController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _claveAntiguaController.dispose();
    _nuevaClaveController.dispose();
    _repetirClaveController.dispose();
    super.dispose();
  }

  // Función de validación genérica (ejemplo)
  String? _validarCampo(String? value, String campo) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa $campo';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userControllerProvider);

    _nombreController.text = user.name ?? '';
    _documentoController.text = user.documentNumber ?? '';
    _emailController.text = user.email ?? '';
    _telefonoController.text = user.phone ?? '';
    _direccionController.text = user.mainAddress ?? '';

    return SingleChildScrollView(
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'Mi Perfil',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
          ),
        ),
        const SizedBox(width: 40),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: const Text(
            'Editar mis datos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldFormEsvilla(
                  name: 'Nombre',
                  controller: _nombreController,
                  inputType: TextInputType.name,
                  validator: (value) => _validarCampo(value, 'un nombre'),
                ),
                const SizedBox(height: 16),

                TextFieldFormEsvilla(
                  name: 'Documento',
                  controller: _documentoController,
                  inputType: TextInputType.number,
                  validator: (value) => _validarCampo(value, 'un documento'),
                ),
                const SizedBox(height: 16),

                TextFieldFormEsvilla(
                    name: 'Email',
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un correo electrónico';
                      }
                      // Validación básica de email
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Ingresa un correo electrónico válido';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),

                TextFieldFormEsvilla(
                  name: 'Teléfono',
                  controller: _telefonoController,
                  inputType: TextInputType.phone,
                  validator: (value) => _validarCampo(value, 'un teléfono'),
                ),
                const SizedBox(height: 16),

                TextFieldFormEsvilla(
                  name: 'Dirección principal',
                  controller: _direccionController,
                  inputType: TextInputType.streetAddress,
                  validator: (value) =>
                      _validarCampo(value, 'una dirección principal'),
                ),
                const SizedBox(height: 16),

                // Botón para "Guardar"
                Center(
                  child: ButtonRectangular(
                      onPressedFunction: () {
                        if (_formKey.currentState!.validate()) {
                          // Aquí manejas el guardado de datos
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Datos guardados')),
                          );
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.save_as_sharp,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              'Guardar',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      ),
                ),

                const SizedBox(height: 32),

                // Sección: Nueva clave
                const Text(
                  'Nueva clave',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),

                TextFieldFormEsvilla(
                  controller: _claveAntiguaController,
                  name: 'Clave antigua',
                  inputType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) =>
                      _validarCampo(value, 'la clave antigua'),
                ),
                const SizedBox(height: 16),

                TextFieldFormEsvilla(
                  controller: _nuevaClaveController,
                  name: 'Nueva clave',
                  inputType: TextInputType.visiblePassword,
                  validator: (value) => _validarCampo(value, 'la nueva clave'),
                ),
                const SizedBox(height: 16),

                TextFieldFormEsvilla(
                  controller: _repetirClaveController,
                  name: 'Repetir nueva clave',
                  inputType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor repite la nueva clave';
                    }
                    if (value != _nuevaClaveController.text) {
                      return 'Las claves no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(233, 50)),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                    ),
                    onPressed: () {
                      // Validar solo la parte de la nueva clave
                      // Si quieres validar todo el form, usa _formKey.currentState!.validate()
                      if (_claveAntiguaController.text.isEmpty ||
                          _nuevaClaveController.text.isEmpty ||
                          _repetirClaveController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Completa todos los campos de clave'),
                          ),
                        );
                        return;
                      }
                      if (_nuevaClaveController.text !=
                          _repetirClaveController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Las nuevas claves no coinciden'),
                          ),
                        );
                        return;
                      }
                      // Aquí manejas el cambio de clave
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Clave cambiada')),
                      );
                    },
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.lock_reset_sharp,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              'Cambiar clave',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
