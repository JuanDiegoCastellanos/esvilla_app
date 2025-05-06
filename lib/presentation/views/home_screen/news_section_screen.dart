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
        ),
        NewsSection(),
      ]),
    );
  }
}
