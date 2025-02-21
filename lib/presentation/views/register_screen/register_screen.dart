import 'package:esvilla_app/core/constants/app_texts.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _documentController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();
  final _direccionController = TextEditingController();

  static const requiredField = "Este campo es obligatorio";

  @override
  void dispose() {
    _nameController.dispose();
    _documentController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _passwordAgainController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Oculta el teclado
    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final document = _documentController.text.trim();
    final email = _emailController.text.trim();
    final telefono = _telefonoController.text.trim();
    final password = _passwordController.text.trim();
    final passwordAgain = _passwordAgainController.text.trim();
    final direccion = _direccionController.text.trim();

    if (name.isNotEmpty &&
        document.isNotEmpty &&
        email.isNotEmpty &&
        telefono.isNotEmpty &&
        password.isNotEmpty &&
        passwordAgain.isNotEmpty && 
        direccion.isNotEmpty) {
      if (password == passwordAgain) {
        try {
          await ref.read(authControllerProvider.notifier).register(
                name,
                document,
                email,
                telefono,
                password,
                direccion,
              );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Bienvenido!'),
              backgroundColor: Colors.green,
            ),
          );
        } on AppException catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.code == 401
                  ? 'Email o contraseña incorrectos'
                  : e.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Las contraseñas no coinciden'),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Los campos son obligatorios'),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: <Color>[Color(0xFF82D8FF), Color(0xFFFFFFFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.56, 1.0],
      )),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/img/logoEsvillaOficial.png',
                width: 260,
                height: 160,
              ), // image
              Column(
                children: [
                  const Text(
                    'Registro',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      color: Color.fromRGBO(47, 39, 125, 1),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  newLabelText(context, 'Nombre Completo: '),
                  newInputField(_nameController, requiredField),
                  const SizedBox(height: 20),
                  newLabelText(context, 'Nro. Documento: '),
                  newInputField(_documentController, requiredField),
                  const SizedBox(height: 20),
                  newLabelText(context, 'Correo electronico o email: '),
                  newInputField(_emailController, requiredField),
                  const SizedBox(height: 20),
                  newLabelText(context, 'Telefono: '),
                  newInputField(_telefonoController, requiredField),
                  const SizedBox(height: 20),
                  newLabelText(context, 'Direccion: '),
                  newInputField(_direccionController, requiredField),
                  const SizedBox(height: 20),
                  newLabelText(context, 'Contraseña: '),
                  newInputField(_passwordController, requiredField, obscure: true),
                  const SizedBox(height: 20),
                  newLabelText(context, 'Contraseña nuevamente: '),
                  newInputField(_passwordAgainController, requiredField, obscure: true),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(233, 50)),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromRGBO(47, 39, 125, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    onPressed: _register,
                    child: authState.isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          )
                        : const Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600
                                ),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: const Text(
                      AppTexts.termsAndPrivacy,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                         ),
                      textAlign: TextAlign.center,
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

  Widget newLabelText(BuildContext context, String text) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget newInputField(TextEditingController controller, String error, {bool obscure=false}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 40,
      child: TextFieldBox(
        controller: controller,
        errorMessage: error,
      ),
    );
  }
}
