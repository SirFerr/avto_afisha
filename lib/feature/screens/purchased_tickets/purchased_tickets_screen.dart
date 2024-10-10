import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/ticket_model.dart';

class PurchasedTicketsScreen extends StatelessWidget {
  final faker = Faker();
  final random = Random();

// Генерация случайных данных для списка билетов
  List<Ticket> generateRandomTickets(int count) {
    return List.generate(count, (index) {
      return Ticket(
        eventName: faker.lorem.words(3).join(' '),
        date: DateTime.now().add(Duration(days: random.nextInt(30))),
        location: faker.address.city(),
        price: (random.nextDouble() * 100).roundToDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var tickets = generateRandomTickets(10);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Купленные билеты'),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return GestureDetector(
            onTap: () {
              // Переход на экран билета с передачей данных
              context.push(
                '/ticket',
                extra: {
                  'eventName': ticket.eventName,
                  'date': ticket.date,
                  'location': ticket.location,
                  'price': ticket.price,
                },
              );
            },
            child: Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.eventName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        'Дата: ${ticket.date.toLocal().toString().split(' ')[0]}'),
                    const SizedBox(height: 8),
                    Text('Место: ${ticket.location}'),
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
