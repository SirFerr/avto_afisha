import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'dart:math';
import '../../../../models/event_model.dart';
import 'widgets/event_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final faker = Faker();
  final random = Random();

  // Генерация случайных данных для списка событий
  List<Event> generateRandomEvents(int count) {
    return List.generate(count, (index) {
      return Event(
        eventName: faker.lorem.words(3).join(' '),
        description: faker.lorem.sentences(2).join(' '),
        imageUrl: 'https://picsum.photos/seed/${random.nextInt(1000)}/300/200',
        rating: random.nextBool() ? random.nextDouble() * 5 : null,
        date: DateTime.now().add(Duration(days: random.nextInt(30))),
        location: faker.address.city(),
        price: (random.nextDouble() * 100).roundToDouble(),
        comments: List.generate(5, (i) => faker.lorem.sentence()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Генерируем список случайных событий
    final List<Event> events = generateRandomEvents(10);

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
