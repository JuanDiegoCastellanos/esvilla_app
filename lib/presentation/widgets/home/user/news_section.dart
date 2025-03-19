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
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Card(
                  color: Colors.blue.shade100,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(item.text,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        item.image ?? Container(),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList());
  }
}
