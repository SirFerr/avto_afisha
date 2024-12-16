import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../models/exhibition_model.dart';

class EventCard extends StatelessWidget {
  final Exhibition exhibition;

  const EventCard({super.key, required this.exhibition});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/event',
          extra: {
            'id': exhibition.id,
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
                exhibition.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Дата мероприятия
              Text(
                'Дата: ${exhibition.date}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
