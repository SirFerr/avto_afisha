import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketScreen extends StatelessWidget {
  final String eventName;
  final DateTime date;
  final String location;
  final double price;

  const TicketScreen({
    super.key,
    required this.eventName,
    required this.date,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Билет'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Дата: ${DateFormat.yMMMMd().format(date)}'),
            const SizedBox(height: 8),
            Text('Место: $location'),
            const SizedBox(height: 8),
            Text('Цена: \$$price'),
            const SizedBox(height: 24),
            // Псевдо штрих-код
            Center(
              child: Container(
                width: 200,
                height: 80,
                color: Colors.black12,
                child: const Center(
                  child: Text(
                    '|| ||| | || || ||| | | || || |||',
                    style: TextStyle(fontSize: 24, letterSpacing: 2.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
