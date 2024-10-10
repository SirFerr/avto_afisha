import 'package:flutter/material.dart';
import 'event_model.dart';
import 'widgets/event_card.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  // Пример данных событий
  final List<Event> events = [
    Event(
      imageUrl: 'https://example.com/event1.jpg',
      description: 'Музей современного искусства',
      rating: 4.5,
      commentCount: 24,
      date: DateTime.now().add(const Duration(days: 2)),
    ),
    Event(
      imageUrl: 'https://example.com/event2.jpg',
      description: 'Концерт классической музыки',
      rating: null,
      commentCount: 15,
      date: DateTime.now().add(const Duration(days: 5)),
    ),
    // Добавьте больше событий по необходимости
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(event: events[index]);
        },
      ),
    );
  }
}
