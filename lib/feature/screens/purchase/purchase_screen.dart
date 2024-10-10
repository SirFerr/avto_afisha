import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PurchaseScreen extends StatelessWidget {
  final String eventName;
  final DateTime date;
  final String location;
  final double price;

  const PurchaseScreen({
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
        title: const Text('Покупка билета'),
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
            Text(
              'Дата: ${DateFormat.yMMMMd().format(date)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Место: $location',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Цена: \$$price',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Оплатить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
