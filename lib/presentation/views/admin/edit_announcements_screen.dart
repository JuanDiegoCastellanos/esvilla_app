import 'dart:convert';
import 'dart:io';

import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/presentation/providers/announcements/all_announcements_provider.dart';
import 'package:esvilla_app/presentation/providers/announcements/announcements_list_state_notifier_provider.dart';
import 'package:esvilla_app/presentation/providers/announcements/announcements_model_presentation.dart';
import 'package:esvilla_app/presentation/views/admin/admin_home_screen.dart';
import 'package:esvilla_app/presentation/widgets/shared/button_rectangular.dart';
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';
import 'package:esvilla_app/presentation/widgets/shared/title_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditAnnouncementScreen extends ConsumerStatefulWidget {
  final dynamic announcement;
  const EditAnnouncementScreen({super.key, this.announcement});

  @override
  ConsumerState<EditAnnouncementScreen> createState() =>
      _EditAnnouncementScreenState();
}

class _EditAnnouncementScreenState
    extends ConsumerState<EditAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleC;
  late final TextEditingController _descC;
  late final TextEditingController _bodyC;
  String? _mainImageBase64;
  String? _secondaryImageBase64;
  XFile? _mainFile;
  XFile? _secondaryFile;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final a = widget.announcement;
    _titleC = TextEditingController(text: a?.title);
    _descC = TextEditingController(text: a?.description);
    _bodyC = TextEditingController(text: a?.body);
    _mainImageBase64 = a?.mainImage;
    _secondaryImageBase64 = a?.secondaryImage;
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    _bodyC.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool primary) async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    final b64 = base64Encode(bytes);
    setState(() {
      if (primary) {
        _mainFile = picked;
        _mainImageBase64 = b64;
      } else {
        _secondaryFile = picked;
        _secondaryImageBase64 = b64;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_mainImageBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar imagen principal')),
      );
      return;
    }
    setState(() => _isSubmitting = true);

    final model = AnnouncementPresentationModel(
      id: widget.announcement?.id,
      title: _titleC.text.trim(),
      description: _descC.text.trim(),
      body: _bodyC.text.trim(),
      mainImage: _mainImageBase64,
      secondaryImage: _secondaryImageBase64,
      publicationDate: widget.announcement?.publicationDate ?? DateTime.now(),
    );

    try {
      final success = widget.announcement != null
          ? await ref.read(updateAnnouncementProvider(model).future) : false;

      if (success) {
        ref.read(goRouterProvider).pop();
        await ref
            .read(announcementsListControllerProvider.notifier)
            .loadInitialNews();
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.announcement == null
                ? 'Anuncio creado con éxito'
                : 'Anuncio actualizado con éxito'),
            backgroundColor: Colors.green,
          ),
        );
        }
      } else {
        if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.announcement == null
                ? 'Error creando anuncio'
                : 'Error actualizando anuncio'),
            backgroundColor: Colors.red,
          ),
        );
        }
      }
    } catch (e) {
      final errorMessage = e is AppException 
          ? e.message 
          : 'Ha ocurrido un error inesperado';
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                TitleSection(
                  titleText: 'Editar Anuncio o Noticia'
                  
                  ),
                const SizedBox(height: 24),

                // Título
                TextFieldFormEsvilla(
                  controller: _titleC,
                  name: 'Título',
                  inputType: TextInputType.text,
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 100,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Título es requerido' : null,
                ),
                const SizedBox(height: 16),

                // Descripción
                TextFieldFormEsvilla(
                  controller: _descC,
                  name: 'Descripción',
                  inputType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  maxLength: 300,
                  validator: (v) => v == null || v.isEmpty
                      ? 'Descripción es requerida'
                      : null,
                ),
                const SizedBox(height: 16),

                // Imagen Principal Picker
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Imagen Principal',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _mainFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_mainFile!.path),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : (_mainImageBase64 != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      base64Decode(_mainImageBase64!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey,
                                  )))),
                    const SizedBox(height: 8),
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.edit, size: 28),
                        onPressed: () => _pickImage(true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Cuerpo
                TextFieldFormEsvilla(
                  controller: _bodyC,
                  name: 'Cuerpo del anuncio',
                  inputType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  maxLength: 1000,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Cuerpo es requerido' : null,
                ),
                const SizedBox(height: 16),

                // Segunda Imagen Picker
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Segunda Imagen',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _secondaryFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_secondaryFile!.path),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : (_secondaryImageBase64 != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      base64Decode(_secondaryImageBase64!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey,
                                  )))),
                    const SizedBox(height: 8),
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.edit, size: 28),
                        onPressed: () => _pickImage(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Botón Guardar / Loader
                _isSubmitting
                    ? const CircularProgressIndicator()
                    : ButtonRectangular(
                        onPressedFunction: _save,
                        size: WidgetStatePropertyAll(Size(250, 50)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.announcement == null
                                  ? Icons.save
                                  : Icons.save_outlined,
                              size: 28,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.announcement == null
                                    ? 'Crear Anuncio'
                                    : 'Guardar Cambios',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
