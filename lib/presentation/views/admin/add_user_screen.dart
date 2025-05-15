import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/presentation/providers/user/all_users_controller_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_model_presentation.dart';
import 'package:esvilla_app/presentation/views/admin/edit_user_screen.dart';
import 'package:esvilla_app/presentation/views/screens.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_box.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddUserScreen extends ConsumerStatefulWidget {
  const AddUserScreen({super.key});

  @override
  ConsumerState<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends ConsumerState<AddUserScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final UserEntity user;

  @override
  void dispose() {
    nameController.dispose();
    documentController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void createUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final name = nameController.text;
        final documentNumber = documentController.text;
        final email = emailController.text;
        final phone = phoneController.text;
        final mainAddress = addressController.text;
        final passwordTemp = documentNumber;

        final userUpdated = UserPresentationModel.partly(
            name: name,
            documentNumber: documentNumber,
            email: email,
            phone: phone,
            mainAddress: mainAddress,
            password: passwordTemp,
            role: 'user');
        await ref
            .read(allUsersControllerProvider.notifier)
            .addUser(UserPresentationModel.fromEntity(UserPresentationModel.toEntity(userUpdated)));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: const Text(
                  'Usuario creado!',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Error creando usuario',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE4F7FF),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const EsvillaAppBar(),
                const Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Editar usuario: ',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20, left: 10),
                              child: LabelText(
                                text: 'Nombre: ',
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10),
                              child: newInputField(
                                  context, nameController, 'Nombre'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20, left: 10),
                              child: Text(
                                'Documento:',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10),
                              child: newInputField(
                                  context, documentController, 'Documento'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20, left: 10),
                              child: LabelText(
                                text: 'Email: ',
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10),
                              child: newInputField(
                                  context, emailController, 'Email'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20, left: 10),
                              child: LabelText(
                                text: 'Teléfono: ',
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10),
                              child: newInputField(
                                  context, phoneController, 'Telefono'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: LabelText(
                                text: 'Direccion Principal: ',
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10),
                              child: newInputField(context, addressController,
                                  'Direccion Principal'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ButtonRectangular(
                        onPressedFunction: () {
                          if (_formKey.currentState!.validate()) {
                            createUser();
                            Future.delayed(const Duration(seconds: 2)).then(
                                (value) => ref.read(goRouterProvider).pop());
                          }
                        },
                        size: const WidgetStatePropertyAll(Size(300, 50)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save,
                              size: 32,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Crear Nuevo Usuario',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  SizedBox newInputField(
      BuildContext context, TextEditingController controller, String name,
      {Validator? validator}) {
    return SizedBox(
      height: 65,
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFieldFormEsvilla(
          name: name,
          inputType: TextInputType.text,
          controller: controller,
          validator: validator),
    );
  }
}
