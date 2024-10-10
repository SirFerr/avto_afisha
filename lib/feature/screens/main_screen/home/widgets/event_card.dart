import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../models/event_model.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
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
                event.description,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Дата мероприятия
              Text(
                'Дата: ${event.date.toLocal().toString().split(' ')[0]}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
