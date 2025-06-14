import 'package:esvilla_app/presentation/providers/announcements/announcements_list_state_notifier_provider.dart';
import 'package:esvilla_app/presentation/widgets/home/user/news_section.dart';
import 'package:esvilla_app/presentation/widgets/shared/title_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsSectionScreen extends ConsumerWidget {
  const NewsSectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref
                .read(announcementsListControllerProvider.notifier)
                .loadInitialNews(),
      child: ListView(
        children:[
        TitleSection(titleText: 'Últimas Noticias o Informes'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Text(
            'Descubre las noticias más relevantes y accede a informes públicos de interés ciudadano.\n'
            '\nAprende sobre impactos ambientales y recibe consejos prácticos de reciclaje y manejo de residuos para adoptar un estilo de vida más sostenible y proteger tu entorno.\n'
            '\nConoce cómo tus acciones individuales pueden transformar nuestra comunidad en un espacio más ecológico y responsable.\n',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        NewsSection(),
      ]),
    );
  }
}
