import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatelessWidget {
  final String eventName;
  final String description;
  final List<String> imageUrls;
  final double rating;
  final DateTime date;
  final String location;
  final double price;

  const EventDetails({
    super.key,
    required this.eventName,
    required this.description,
    required this.imageUrls,
    required this.rating,
    required this.date,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Название события
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            eventName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        // Картинки
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(imageUrls[index]),
              );
            },
          ),
        ),
        // Рейтинг
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              RatingBarIndicator(
                rating: rating,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
              const SizedBox(width: 8),
              Text('${rating.toStringAsFixed(1)}/5'),
            ],
          ),
        ),
        // Дата, место и цена
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Дата: ${DateFormat.yMMMMd().format(date)}'),
              const SizedBox(height: 8),
              Text('Место: $location'),
              const SizedBox(height: 8),
              Text('Цена: \$$price'),
            ],
          ),
        ),
        // Описание
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            description,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Кнопка "Купить"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              context.push(
                '/purchase',
                extra: {
                  'eventName': eventName,
                  'date': date,
                  'location': location,
                  'price': price,
                },
              );
            },
            child: const Text('Купить'),
          ),
        ),
      ],
    );
  }
}
