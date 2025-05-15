import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/presentation/providers/announcements/all_announcements_provider.dart';
import 'package:esvilla_app/presentation/providers/announcements/announcements_list_state_notifier_provider.dart';
import 'package:esvilla_app/presentation/providers/announcements/announcements_model_presentation.dart';
import 'package:esvilla_app/presentation/views/admin/admin_home_screen.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/skeleton_box.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_box.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddAnnouncementScreen extends ConsumerStatefulWidget {
  const AddAnnouncementScreen({super.key});

  @override
  ConsumerState<AddAnnouncementScreen> createState() =>
      _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends ConsumerState<AddAnnouncementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController secondImageController = TextEditingController();
  String? _imageBase64;
  String? _secondImageBase64;
  XFile? _imageFile;
  XFile? _secondImageFile;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  Future<void> _pickImage({required bool primary}) async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      final base64 = base64Encode(bytes);
      setState(() {
        if (primary) {
          _imageFile = picked;
          _imageBase64 = base64;
        } else {
          _secondImageFile = picked;
          _secondImageBase64 = base64;
        }
      });
    }
  }

  Future<void> createAnnouncement() async {
    if (!_formKey.currentState!.validate() || _imageBase64 == null) return;

    setState(() => isLoading = true);

    final newAnnouncement = AnnouncementPresentationModel(
      title: titleController.text,
      description: descriptionController.text,
      mainImage: _imageBase64,
      body: bodyController.text,
      secondaryImage: _secondImageBase64,
      publicationDate: DateTime.now(),
    );
    final result =
        await ref.read(addAnnouncementProvider(newAnnouncement).future);

    setState(() => isLoading = false);

    if (result) {
      ref.read(goRouterProvider).pop();
      await ref
          .read(announcementsListControllerProvider.notifier)
          .loadInitialNews();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Usuario creado con exito',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
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

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    bodyController.dispose();
    super.dispose();
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Crear anuncio:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildRow(
                        child: newInputField(
                          context: context,
                          controller: titleController,
                          name: 'Titulo',
                          maxLength: 50,
                          minLength: 10,
                          maxLines: 2,
                          minLines: 1,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Titulo es requerido'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Imagen Principal',
                              style: TextStyle(fontSize: 20)),
                          GestureDetector(
                            onTap: () => _pickImage(primary: true),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: _imageFile == null
                                  ? const Center(
                                      child: Icon(Icons.add_photo_alternate,
                                          size: 40, color: Colors.grey))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(_imageFile!.path),
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ),
                          _imageFile == null
                              ? Container()
                              : IconButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      _imageFile = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    size: 30,
                                  ),
                                )
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildRow(
                        child: newInputField(
                          context: context,
                          controller: descriptionController,
                          name: 'Descripcion',
                          maxLength: 700,
                          minLength: 100,
                          maxLines: null,
                          minLines: 3,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Descripcion es requerida'
                              : null,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Segunda Imagen',
                              style: TextStyle(fontSize: 20)),
                          GestureDetector(
                            onTap: () => _pickImage(primary: false),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: _secondImageFile == null
                                  ? const Center(
                                      child: Icon(Icons.add_photo_alternate,
                                          size: 40, color: Colors.grey))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(_secondImageFile!.path),
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ),
                          _secondImageFile == null
                              ? Container()
                              : IconButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      _secondImageFile = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    size: 30,
                                  ),
                                )
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildRow(
                        child: newInputField(
                          context: context,
                          controller: bodyController,
                          name: 'Cuerpo del anuncio',
                          maxLength: 1000,
                          minLength: 200,
                          maxLines: null,
                          minLines: 3,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Cuerpo es requerido'
                              : null,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ButtonRectangular(
                        color: Colors.black,
                        onPressedFunction: () {
                          final item = AnnouncementPresentationModel(
                            title: titleController.text,
                            description: descriptionController.text,
                            mainImage: _imageBase64,
                            body: bodyController.text,
                            secondaryImage: _secondImageBase64,
                            createdAt: DateTime.now(),
                          );
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            isDismissible: true,
                            enableDrag: true,
                            clipBehavior: Clip.hardEdge,
                            barrierColor: Colors.black.withValues(alpha: 0.5),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return _buildNewsDetailSheet(context, item, ref);
                            },
                          );
                        },
                        child: const Text(
                          "Ver previsualización",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : ButtonRectangular(
                                onPressedFunction: () async {
                                  if (_imageFile == null || _secondImageFile == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Debes seleccionar las dos imagenes',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                  await createAnnouncement();
                                }
                                },
                                size:
                                    const WidgetStatePropertyAll(Size(300, 50)),
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
                                          'Crear Anuncio o Noticia',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildRow({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(flex: 3, child: child),
        ],
      ),
    );
  }

  Widget newInputField(
      {required BuildContext context,
      required TextEditingController controller,
      required String name,
      int? maxLength,
      int? minLength,
      int? maxLines = 1,
      int minLines = 1,
      Validator? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: TextFieldFormEsvilla(
            name: name,
            minLines: minLines,
            maxLines: maxLines,
            minLength: minLength ?? 6,
            maxLength: maxLength,
            inputType: TextInputType.text,
            controller: controller,
            validator: validator),
      ),
    );
  }

  Uint8List decodeBase64Image(String data) {
    // Si viene con "data:image/…;base64,", lo quitamos:
    final regex = RegExp(r'data:image/[^;]+;base64,');
    final base64Str = data.replaceAll(regex, '');
    return Base64Decoder().convert(base64Str);
  }

  Widget _buildNewsDetailSheet(
      BuildContext context, AnnouncementPresentationModel item, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: (item.title ?? '').isNotEmpty
                            ? Text(
                                item.title!,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              )
                            : const SkeletonBox(height: 26),
                      ),
                      Text(
                        'Fecha: ${item.createdAt?.year}-${item.createdAt?.month}-${item.createdAt?.day} ${item.createdAt?.hour}:${item.createdAt?.minute}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(_imageFile!.path),
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    );
                                  },
                                ),
                              )
                            : SkeletonBox(
                                height: 400,
                              ),
                      ),
                      const SizedBox(height: 16),
                      // Contenido detallado de la noticia
                      /* Text(
                        item.description ?? '',
                        style: TextStyle(fontSize: 20),
                      ), */
                      if ((item.description ?? '').isNotEmpty)
                        Text(item.description!,
                            style: const TextStyle(fontSize: 18))
                      else
                        const SkeletonBox(height: 100),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        child: _secondImageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(_secondImageFile!.path),
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    );
                                  },
                                ),
                              )
                            : SkeletonBox(
                                height: 400,
                              ),
                      ),
                      const SizedBox(height: 16),
                      if ((item.body ?? '').isNotEmpty)
                        Text(
                          item.body ?? '',
                          style: TextStyle(fontSize: 18),
                        )
                      else
                        const SkeletonBox(height: 100),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
