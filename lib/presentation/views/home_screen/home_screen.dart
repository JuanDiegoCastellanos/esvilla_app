import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/utils/mocks/news_images.mock.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/views/home_screen/schedule.mock.dart';
import 'package:esvilla_app/presentation/widgets/home/user/home_bottom_navigation.dart';
import 'package:esvilla_app/presentation/widgets/home/user/item_news.dart';
import 'package:esvilla_app/presentation/widgets/home/user/news_section.dart';
import 'package:esvilla_app/presentation/widgets/home/user/schedule_card.dart';
import 'package:esvilla_app/presentation/widgets/home/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

// idea manejar los horarios de [HorarioRecoleccion] recoleccion de basura diarios, mostrando la hora y los sectores de recoleccion desde 
// la API
// hora , sector, dia 
// por dia listar los sectores de recoleccion y la hora de recoleccion

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home', style: optionStyle),
    Text('Index 1: Business', style: optionStyle),
    Text('Index 2: School', style: optionStyle),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
  Widget build(BuildContext context) {
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
                    const UserInfo(),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: GestureDetector(
                        onTap: () {
                          auth.logout();
                        },
                        child: const Icon(
                          Icons.logout,
                          color: Colors.red,
                          size: 45,
                        ),
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
          NewsSection(
            newsList: itemsNews,
          ),
          const SizedBox(
            height: 40,
            child: Center(
              child: Text(
                'Ver más',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dashed,
                    decorationColor: Colors.blueAccent),
              ),
            ),
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
              'Horarios De Recoleccion',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Column(
            children: mockSchedule.days.map(
              (e) => GestureDetector(
                onTap: (){
                  ref.read(goRouterProvider).pushNamed('schedule', extra: e);
                },
                child: ScheduleCard(name: e.name),
              ),
            ).toList()
          ),
        ]),
      ),
      bottomNavigationBar: const HomeBottomNavigation(),
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