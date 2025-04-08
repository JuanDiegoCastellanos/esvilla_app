import 'package:esvilla_app/core/utils/mocks/news_images.mock.dart';
import 'package:esvilla_app/presentation/widgets/home/user/item_news.dart';
import 'package:esvilla_app/presentation/widgets/home/user/news_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsSectionScreen extends ConsumerWidget {
  NewsSectionScreen({super.key});

  final List<ItemNews> itemsNews = [
    ItemNews(
        icon: Icons.person,
        text:
            'Esta es un simulacion de una noticia real, que le puede importar al usuario',
        image: Image.network(
          newsImages['noticiaDeReciclaje']!,
          fit: BoxFit.cover,
        )),
    ItemNews(
        icon: Icons.receipt,
        text: 'Otra noticia con alguna informacion relevante',
        image: Image.network(newsImages['villaDeLeyva']!)),
    ItemNews(
        icon: Icons.event_note,
        text:
            'Informacion para enseñar al cuidado y al reciclaje, estos textos son temporales, se deben reemplazar',
        image: Image.network(newsImages['reciclaje']!)),
    ItemNews(
        icon: Icons.upload_file,
        text:
            'Descripcion que se quiera poner, esto solo es una prueba, aca va algo de texto repecto a la importancia de las 3 R',
        image: Image.network(newsImages['tresR']!)),
    ItemNews(
        icon: Icons.home,
        text:
            'Aprender sobre el reciclaje, tambien se pueden poner noticias de los horarios de reciclaje y las personas pueden ver mas facilmente',
        image: Image.network(newsImages['noticiaDeReciclaje']!)),
    ItemNews(
        icon: Icons.announcement,
        text:
            'Informacion sobre la recoleccion de residuos, se pueden poner mas informacion de la recoleccion de residuos',
        image: Image.network(newsImages['noticiaDeRecoleccion']!)),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(children: [
      Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: 10,
        ),
        width: double.infinity,
        child: const Text(
          'Ultimas Noticias',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      NewsSection(
        onClick: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            isDismissible: true,
            barrierColor: Colors.black.withOpacity(0.5),
            builder: (context) {
              return DraggableScrollableSheet(
                // Define tamaños inicial, mínimo y máximo según lo que necesites.
                initialChildSize: 0.5,
                minChildSize: 0.3,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    // Agregamos una decoración para darle un look moderno.
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
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
                        // "Handle" para indicar que se puede arrastrar.
                        Row(                          
                          children: [
                            // Handle centrado
                            Expanded(
                              child: Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            // Botón de cierre
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        // Contenido desplazable.
                        Expanded(
                          child: ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  );
                },
              );
            },
          );
        },
        newsList: itemsNews,
      ),
    ]);
  }
}
