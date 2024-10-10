import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../models/event_model.dart';


class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final faker = Faker();
  final random = Random();

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
    // Генерация случайных данных для избранных мероприятий
    final List<Event> events = generateRandomEvents(10);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные мероприятия'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return GestureDetector(
            onTap: () {
              // Переход на экран события при нажатии на карточку
              context.push(
                '/event',
                extra: {
                  'eventName': event.description,
                  'description': event.description,
                  'imageUrls': [event.imageUrl],
                  'rating': event.rating ?? 0.0,
                  'date': event.date,
                  'location': event.location,
                  'price': event.price,
                  'comments': event.comments,
                },
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название мероприятия
                    Text(
                      event.eventName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Дата мероприятия
                    Text(
                      'Дата: ${DateFormat.yMMMMd().format(event.date)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    // Место проведения мероприятия
                    Text(
                      'Место: ${event.location}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}