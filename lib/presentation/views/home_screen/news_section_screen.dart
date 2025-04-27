import 'package:esvilla_app/core/utils/mocks/news_images.mock.dart';
import 'package:esvilla_app/presentation/widgets/home/user/item_news.dart';
import 'package:esvilla_app/presentation/widgets/home/user/news_section.dart';
import 'package:esvilla_app/presentation/widgets/shared/title_section.dart';
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
      TitleSection(titleText: 'Últimas Noticias o Informes'),
      const Text(
        'Infórmate de las noticias más recientes e informes públicos a los que el ciudadano puede acceder.\n '
        '\nAprende sobre los impactos ambientales, consejos de reciclaje y manejo de residuos que te ayudarán a '
        ' vivir de una manera más sostenible y a cuidar tu entorno.\n '
        '\nDescubre cómo puedes contribuir a una comunidad más ecológica y responsable.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
      ),
      NewsSection(
        newsList: itemsNews,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextButton(
          onPressed: () {
            // Agrega la lógica para cargar más noticias
          },
          child: Text(
            'Ver más',
            style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 18,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue.shade800),
          ),
        ),
      ),
    ]);
  }
}
