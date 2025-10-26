import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:esvilla_app/presentation/widgets/shared/text_field_form_esvilla.dart';

class AddressAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final String name;
  final int maxLength;
  final int minLength;
  final String? Function(String?) validator;

  const AddressAutocompleteField({
    super.key,
    required this.controller,
    required this.name,
    required this.maxLength,
    required this.minLength,
    required this.validator,
  });

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  List<String> suggestions = [];
  bool isLoading = false;
  bool showSuggestions = false;
  Timer? _debounceTimer;

  Future<void> searchAddress(String query) async {
    if (query.length < 3) {
      setState(() {
        suggestions = [];
        showSuggestions = false;
      });
      return;
    }

    setState(() => isLoading = true);

    try {
      final uri = Uri.parse('https://nominatim.openstreetmap.org/search')
          .replace(queryParameters: {
        'q': query,
        'format': 'json',
        'countrycodes': 'co',
        'limit': '5',
        'addressdetails': '1',
      });

      final response = await http.get(
        uri,
        headers: {'User-Agent': 'EsvillaApp/1.0'},
      );

      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body) as List;
        setState(() {
          suggestions =
              data.map((item) => item['display_name'] as String).toList();
          showSuggestions = suggestions.isNotEmpty;
          isLoading = false;
        });
      } else if (mounted) {
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          suggestions = [];
          showSuggestions = false;
          isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        showSuggestions = false;
        suggestions = [];
      });
      return;
    }

    // Cancelar timer anterior si existe
    _debounceTimer?.cancel();

    // Crear nuevo timer con debounce de 500ms
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      searchAddress(value);
    });
  }

  void selectSuggestion(String suggestion) {
    widget.controller.text = suggestion;
    setState(() {
      showSuggestions = false;
      suggestions = [];
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            TextFieldFormEsvilla(
              name: widget.name,
              controller: widget.controller,
              maxLength: widget.maxLength,
              minLength: widget.minLength,
              inputType: TextInputType.streetAddress,
              validator: widget.validator,
              onChanged: _onSearchChanged,
            ),
            if (isLoading)
              const Positioned(
                right: 40,
                top: 20,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
        if (showSuggestions && suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: suggestions.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    suggestion,
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () => selectSuggestion(suggestion),
                );
              },
            ),
          ),
      ],
    );
  }
}
