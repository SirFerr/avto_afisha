import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventAppBar extends StatelessWidget {
  final String eventName;
  final String imageUrl;

  const EventAppBar({
    super.key,
    required this.eventName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(eventName),
        background: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.pop();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            // Логика добавления в избранное
          },
        ),
      ],
    );
  }
}
