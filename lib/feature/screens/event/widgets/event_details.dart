import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../models/exhibition_model.dart';

class EventDetails extends StatelessWidget {
  final Exhibition exhibition;

  const EventDetails({
    super.key,
    required this.exhibition,
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
            exhibition.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        // Картинки
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 1,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: exhibition.image,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
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
                rating: exhibition.rating ?? 0.0,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
              const SizedBox(width: 8),
              Text('${(exhibition.rating ?? 0.0).toStringAsFixed(1)}/5'),
            ],
          ),
        ),
        // Дата, место и цена
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Дата: ${DateFormat.yMMMMd().format(DateTime.parse(exhibition.date))}'),
              const SizedBox(height: 8),
              Text('Место: ${exhibition.location}'),
              const SizedBox(height: 8),
              Text('Цена: \$${exhibition.price}'),
            ],
          ),
        ),
        // Описание
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            exhibition.description,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Кнопка "Купить"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Логика покупки события
            },
            child: const Text('Купить'),
          ),
        ),
      ],
    );
  }
}