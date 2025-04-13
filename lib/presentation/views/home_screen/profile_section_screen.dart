import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/presentation/providers/user/get_my_user_profile_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/user/get_user_by_id_provider.dart';
import 'package:esvilla_app/presentation/providers/user/update_user_controller_provider.dart';
import 'package:esvilla_app/presentation/providers/user/update_user_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_model_presentation.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:flutter/cupertino.dart';
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
  final _formKeyPasswords = GlobalKey<FormState>();

  // Controladores de los campos
  final _nameController = TextEditingController();
  final _documentController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _adressController = TextEditingController();

  // Campos para la sección de contraseña
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _controllersInitialized = false;

  late final Future<UserPresentationModel> _userFuture;
  dynamic localUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Liberar los controladores
    _nameController.dispose();
    _documentController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _adressController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _initializeControllers(UserPresentationModel user) {
    // Solo inicializa si no lo has hecho antes o si los datos cambian significativamente
    // (Aunque con StateNotifier, normalmente solo necesitas hacerlo una vez).
    _nameController.text = user.name ?? '';
    _documentController.text = user.documentNumber ?? '';
    _emailController.text = user.email ?? '';
    _phoneController.text = user.phone ?? '';
    _adressController.text = user.mainAddress ?? '';
    _controllersInitialized = true;
  }

  // Función de validación genérica (ejemplo)
  String? _validarCampo(String? value, String campo) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa $campo';
    }
    return null;
  }

  void _updateProfile() async {
    // Construye el modelo con los datos actuales de los controladores
    final currentState = ref.read(updateUserControllerProvider).asData?.value;
    if (currentState == null) return; // No hacer nada si no hay datos

    final updatedModel = currentState.copyWith(
      name: _nameController.text,
      documentNumber: _documentController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      mainAddress: _adressController.text,
      // ¡NO INCLUYAS la contraseña aquí!
    );

    // Llama al método del controlador
    final success = await ref
        .read(updateUserControllerProvider.notifier)
        .updateUserProfile(updatedModel);

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Perfil actualizado correctamente'),
            backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error al actualizar el perfil'),
            backgroundColor: Colors.red),
      );
    }
  }

  void _changePassword() async {
    if (_formKeyPasswords.currentState!.validate()) {
      final oldPasswordInput = _oldPasswordController.text;
      final newPassword = _newPasswordController.text;
      final confirmPassword = _confirmPasswordController.text;

      // Aquí podrías necesitar validar la contraseña antigua contra algún dato seguro,
      // pero idealmente, la validación de la contraseña antigua la hace el backend.
      // El frontend solo necesita enviarla junto con la nueva.

      final success = await ref
          .read(updateUserControllerProvider.notifier)
          .changePassword(oldPasswordInput, newPassword, confirmPassword);

      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Contraseña cambiada correctamente'),
              backgroundColor: Colors.green),
        );
        // Limpiar campos de contraseña después del éxito
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al cambiar la contraseña'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<UserPresentationModel>>(updateUserControllerProvider,
        (previous, next) {
      // Ejemplo: podrías querer mostrar un snackbar específico en transiciones de error/datos
      // O si el controlador manejara estados específicos como 'updateSuccess'
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });

    final user = ref.watch(updateUserControllerProvider);

    return user.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error al cargar perfil: $error')),
        data: (user) {
          // Inicializa los controladores la primera vez que los datos están disponibles
          // Esto es una forma; puede haber otras más elegantes dependiendo de tu flujo exacto.
          // Una alternativa es usar un StatefulWidget anidado solo para el Form que reciba 'user'.
          if (!_controllersInitialized && mounted) {
            // PostFrameCallback para asegurar que el build inicial termine antes de setear texto
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                // Chequear de nuevo por si acaso
                _initializeControllers(user);
              }
            });
          }
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
                        controller: _nameController,
                        inputType: TextInputType.name,
                        validator: (value) => _validarCampo(value, 'un nombre'),
                      ),
                      const SizedBox(height: 16),

                      TextFieldFormEsvilla(
                        name: 'Documento',
                        controller: _documentController,
                        inputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un documento';
                          }
                          if (int.tryParse(value) == null) {
                            return 'El documento debe ser solo números';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFieldFormEsvilla(
                          name: 'Email',
                          maxLength: 30,
                          controller: _emailController,
                          inputType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un correo electrónico';
                            }
                            // Validación básica de email
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Ingresa un correo electrónico válido';
                            }
                            return null;
                          }),
                      const SizedBox(height: 16),

                      TextFieldFormEsvilla(
                        name: 'Teléfono',
                        maxLength: 10,
                        controller: _phoneController,
                        inputType: TextInputType.phone,
                        validator: (value) =>
                            _validarCampo(value, 'un teléfono'),
                      ),
                      const SizedBox(height: 16),

                      TextFieldFormEsvilla(
                        name: 'Dirección principal',
                        maxLength: 40,
                        controller: _adressController,
                        inputType: TextInputType.streetAddress,
                        validator: (value) =>
                            _validarCampo(value, 'una dirección principal'),
                      ),
                      const SizedBox(height: 16),

                      // Botón para "Guardar"
                      Center(
                        child: ButtonRectangular(
                          onPressedFunction: () async {
                            if (_formKey.currentState!.validate()) {
                              // Aquí manejas el guardado de datos
                              _updateProfile();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Datos guardados',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
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
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKeyPasswords,
                    child: Column(
                      children: [
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
                          controller: _oldPasswordController,
                          name: 'Clave antigua',
                          inputType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator: (value) =>
                              _validarCampo(value, 'la clave antigua'),
                        ),
                        const SizedBox(height: 16),

                        TextFieldFormEsvilla(
                          controller: _newPasswordController,
                          name: 'Nueva clave',
                          inputType: TextInputType.visiblePassword,
                          validator: (value) =>
                              _validarCampo(value, 'la nueva clave'),
                        ),
                        const SizedBox(height: 16),

                        TextFieldFormEsvilla(
                          controller: _confirmPasswordController,
                          name: 'Repetir nueva clave',
                          inputType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor repite la nueva clave';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Las claves no coinciden';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        Center(
                          child: ButtonRectangular(
                            onPressedFunction: () {
                              _changePassword();
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
                  ))
            ]),
          );
        });
  }
}
