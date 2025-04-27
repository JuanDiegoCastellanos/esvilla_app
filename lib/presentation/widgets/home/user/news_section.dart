import 'package:esvilla_app/presentation/widgets/home/user/item_news.dart';
import 'package:flutter/material.dart';

class NewsSection extends StatelessWidget {
  final List<ItemNews> newsList;
  const NewsSection({super.key, required this.newsList});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: newsList
            .map(
              (item) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      isDismissible: true,
                      enableDrag: true,
                      clipBehavior: Clip.hardEdge,
                      barrierColor: Colors.black.withValues(alpha: 0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20)
                        )
                      ),
                      builder: (context) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.5,
                          minChildSize: 0.4,
                          maxChildSize: 0.95,
                          expand: false,
                          builder: (context, scrollController) {
                            return GestureDetector(
                              onTap: (){},
                              child: Container(
                                // Agregamos una decoración para darle un look moderno.
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
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
                                    // Contenido desplazable.
                                    Expanded(
                                      child: ListView(
                                        controller: scrollController,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        children: const [
                                          SizedBox(height: 8),
                                          Text(
                                            'Aquí se puede mostrar información adicional de la noticia seleccionada',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Más detalles sobre la noticia, con información relevante para el usuario.',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Incluso puedes agregar más secciones, imágenes, gráficos o lo que necesites.',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          // Agrega más widgets o textos según lo requieras.
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Card(
                    color: Colors.blue.shade100,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          item.image ?? Container(),
                          Text(item.text,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList());
  }
}
