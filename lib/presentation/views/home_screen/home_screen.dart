import 'package:esvilla_app/core/utils/mocks/news_images.mock.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/widgets/home/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final List<ItemNews> itemsNews = [
    ItemNews(
        icon: Icons.person,
        text:
            'Esta es un simulacion de una noticia real, que le puede importar al usuario',
        image: Image.network(
          newsImages['noticiaDeReciclaje']!,
          fit: BoxFit.cover,
        )),
    ItemNews(icon: Icons.receipt, 
    text: 'Otra noticia con alguna informacion relevante',
     image: Image.network(newsImages['villaDeLeyva']!)
     ),
    ItemNews(icon: Icons.event_note, text: 'Informacion para enseñar al cuidado y al reciclaje, estos textos son temporales, se deben reemplazar',
    image: Image.network(newsImages['reciclaje']!)),
    ItemNews(icon: Icons.upload_file, text: 'Descripcion que se quiera poner, esto solo es una prueba, aca va algo de texto repecto a la importancia de las 3 R', 
    image: Image.network(newsImages['tresR']!)
    ),
    ItemNews(icon: Icons.home, text: 'Aprender sobre el reciclaje, tambien se pueden poner noticias de los horarios de reciclaje y las personas pueden ver mas facilmente',
      image: Image.network(newsImages['noticiaDeReciclaje']!)
    ),
    ItemNews(icon: Icons.announcement, text: 'Informacion sobre la recoleccion de residuos, se pueden poner mas informacion de la recoleccion de residuos',
      image: Image.network(newsImages['noticiaDeRecoleccion']!)),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFE4F7FF),
      body: SafeArea(
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 160),
                        child: Image.asset(
                          'assets/img/logoEsvillaOficial.png',
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Juan Diego Castellanos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '1002676988',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        auth.logout();
                      },
                      child: const Icon(
                        Icons.logout,
                        size: 45,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                endIndent: 30,
                indent: 30,
                thickness: 2,
                color: Colors.blue.shade900,
              ),
            ],
          ),
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
                fontSize: 26,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: itemsNews
                            .map(
                              (item) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Card(
                                  color: Colors.blue.shade100,
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Text(
                                          item.text,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600
                                          )
                                          ),
                                        item.image ?? Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        /* List.generate(
                        10, (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Card(
                            color: Colors.blue.shade100,
                            child: Container(
                              height: 100,
                              margin: const EdgeInsets.all(10),
                              child: Center(
                                child: Text('Item $index'),
                              ),
                            ),
                          ),
                        ),
                      ), */
                      ),
                    ),
                  );
                },
              ),
              ),
              SizedBox(height: 40,),
            Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            width: double.infinity,
            child: const Text(
              'Horarios De Recoleccion',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView(
              children: List.generate(
                10, (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        'Horarios de recoleccion \n del dia ${index + 1}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                        ),
                        ),
                    ),
                  ),
                ),
              ),
            ),

          )


        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blue.shade900,
        backgroundColor: Colors.blue.shade100,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.api_rounded),
            label: 'Gestion',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Perfil',
          ),
        ],

      ),
    );
  }
}

/*
Se debe implementar el cambio entre tabs, para poner no solo las noticias si no tambien 
la gestion que es donde debe ir lo de los usuarios y lo que pueden hacer
y en perfil pues habilitar la parte donde pueden cambiar sus datos


en gestion la idea es que aparezcan los container con  los nombres de las cosas que puede 
hacer el usuario, para lo de pagos dejar un boton que dispare un card o algo con la info de como 
pagar por internet

investigar como hacer para que el scroll que esta dentro del layoutbuilder al mover el scroll hasta el top
llame al otro o arrastre el que esta por fuera, ya que el comportamiento individual no es natural y se ve un poco fuerte
lo ideal seria que soi el usuario hace scroll dentro de la seccion de noticias, se mueva esa hasta el max y tenga un boton de leer mas
y carguen mas, pero cuando llegue a ese maximo entonces se haga scroll general y siga bajando para ir a lo que hay debajo

*/