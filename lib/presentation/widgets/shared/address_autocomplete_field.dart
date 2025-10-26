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

    // Buscar en múltiples APIs gratuitas en paralelo
    // Nominatim: API oficial de OpenStreetMap
    // Photon: API rápida de Komoot basada en OpenStreetMap
    final results = await Future.wait([
      _searchWithNominatim(query),
      _searchWithPhoton(query),
    ]);

    // Combinar todos los resultados sin duplicados
    final Set<String> combinedSuggestions = {};
    for (final result in results) {
      combinedSuggestions.addAll(result);
    }

    print('✅ Total sugerencias combinadas: ${combinedSuggestions.length}');
    for (final sug in combinedSuggestions) {
      print('  - $sug');
    }

    if (mounted) {
      setState(() {
        suggestions = combinedSuggestions.toList();
        showSuggestions = true;
        isLoading = false;
      });
    }
  }

  // Búsqueda con Nominatim (OpenStreetMap)
  Future<List<String>> _searchWithNominatim(String query) async {
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

      print('🗺️ Nominatim status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final results =
            data.map((item) => item['display_name'] as String).toList();
        print('🗺️ Nominatim resultados: ${results.length}');
        return results;
      }
    } catch (e) {
      print('❌ Nominatim error: $e');
    }
    return [];
  }

  // Búsqueda con Photon (Komoot)
  Future<List<String>> _searchWithPhoton(String query) async {
    try {
      final uri =
          Uri.parse('https://photon.komoot.io/api/').replace(queryParameters: {
        'q': query,
        'limit': '5',
      });

      final response = await http.get(uri);

      print('🔍 Photon status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map;
        final features = data['features'] as List?;
        if (features != null) {
          final results = features
              .map((feature) {
                final properties = feature['properties'] as Map?;
                if (properties != null) {
                  final name = properties['name'] as String?;
                  final street = properties['street'] as String?;
                  final city = properties['city'] as String?;
                  final state = properties['state'] as String?;

                  if (name != null) {
                    final parts = <String>[];
                    if (name.isNotEmpty) parts.add(name);
                    if (street != null && street.isNotEmpty) parts.add(street);
                    if (city != null && city.isNotEmpty) parts.add(city);
                    if (state != null && state.isNotEmpty) parts.add(state);
                    if (parts.isNotEmpty) return parts.join(', ');
                  }
                }
                return null;
              })
              .whereType<String>()
              .toList();
          print('🔍 Photon resultados: ${results.length}');
          return results;
        }
      }
    } catch (e) {
      print('❌ Photon error: $e');
    }
    return [];
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
    // Mostrar sugerencias si hay texto, tiene al menos 3 caracteres, y no está cargando
    final shouldShowSuggestions = showSuggestions &&
        widget.controller.text.isNotEmpty &&
        widget.controller.text.length >= 3 &&
        !isLoading;

    return GestureDetector(
      onTap: () {
        // Cerrar dropdown cuando se hace clic fuera
        if (shouldShowSuggestions) {
          setState(() {
            showSuggestions = false;
          });
        }
      },
      child: Column(
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
          if (shouldShowSuggestions)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: suggestions.isEmpty
                    ? 1
                    : suggestions.length +
                        1, // +1 para la opción de usar el texto ingresado
                separatorBuilder: (context, index) {
                  // Solo mostrar separador si no es el último item o si no hay sugerencias
                  if (suggestions.isEmpty || index < suggestions.length) {
                    return const Divider(height: 1);
                  }
                  return const SizedBox.shrink();
                },
                itemBuilder: (context, index) {
                  // Si no hay sugerencias, mostrar opción de usar el texto ingresado
                  if (suggestions.isEmpty) {
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.add_location,
                          size: 16, color: Colors.grey),
                      title: Text(
                        widget.controller.text,
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                      trailing: const Text(
                        '(usar esta dirección)',
                        style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey),
                      ),
                      onTap: () {
                        setState(() {
                          showSuggestions = false;
                        });
                      },
                    );
                  }

                  // Si es el último item y hay sugerencias, mostrar opción de usar el texto ingresado
                  if (index == suggestions.length) {
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.add_location,
                          size: 16, color: Colors.grey),
                      title: Text(
                        widget.controller.text,
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                      trailing: const Text(
                        '(usar esta dirección)',
                        style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey),
                      ),
                      onTap: () {
                        setState(() {
                          showSuggestions = false;
                        });
                      },
                    );
                  }

                  // Mostrar sugerencia normal
                  final suggestion = suggestions[index];
                  return ListTile(
                    dense: true,
                    leading:
                        const Icon(Icons.place, size: 16, color: Colors.blue),
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
      ),
    );
  }
}
