import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Pages {
  home,
  news,
  pqrs,
  links,
  profile,
}

class PagesStateNotifier extends StateNotifier<Pages> {
  PagesStateNotifier() : super(Pages.home);

  void changePage(Pages page) {
    state = page;
  } 
}

//provider
final pagesStateProvider =
    StateNotifierProvider<PagesStateNotifier, Pages>(
        (ref) => PagesStateNotifier());

