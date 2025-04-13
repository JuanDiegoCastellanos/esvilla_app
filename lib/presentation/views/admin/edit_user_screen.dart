import 'package:esvilla_app/presentation/views/screens.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  final dynamic user;
  const EditUserScreen({super.key, required this.user});

  @override
  ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
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
                EditUserForm(
                  user: widget.user,
                ),
              ],
            ),
          ),
        ));
  }
}

class EditUserForm extends StatelessWidget {
  final dynamic user;
  EditUserForm({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final documentController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    return Form(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: newInputField(context, nameController, user['name']),
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
                    'Documento :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: newInputField(context, documentController, user['email']),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: newInputField(context, emailController, 'Email'),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: newInputField(context, phoneController, 'Telefono'),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child:
                      newInputField(context, addressController, 'Direccion Principal'),
                ),
              ),
              /*  Padding(
                  padding: EdgeInsets.only(right: 20, left: 10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: double.infinity,
                    ),
                    child: Text(
                      'Direccion Principal',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child:
                    newInputField(context, controller, 'Direccion Principal'),
              ), */
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.lock_reset,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {},
            label: const Text(
              'Resetear Clave',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.cyan.shade300),
              minimumSize: const MaterialStatePropertyAll(Size(200, 50)),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.save,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {},
            label: const Text(
              'Guardar Cambios',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
              minimumSize: const MaterialStatePropertyAll(Size(200, 50)),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox newInputField(
      BuildContext context, TextEditingController controller, String textValue,
      {Validator? validator}) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
          controller: controller,
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.blue, //Color(0xFF4F78FF),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.blue, //Color(0xFF4F78FF),
                width: 1,
              ),
            ),
            hintText: textValue,
          ),
          validator: validator),
    );
  }
}

class LabelText extends StatelessWidget {
  final String text;
  const LabelText({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
    );
  }
}
