import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:faker/faker.dart';
import 'dart:math';
import 'package:faker/faker.dart' as faker;


class EventScreen extends StatelessWidget {
  final faker = Faker();
  final Random random = Random();

  EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Генерация случайных данных
    final String eventName = faker.lorem.words(3).join(' ');
    final String description = faker.lorem.sentences(5).join(' ');
    final List<String> imageUrls = List.generate(
      5,
          (index) => 'https://picsum.photos/seed/${random.nextInt(1000)}/300/200',
    );
    final double rating = random.nextDouble() * 5;
    final DateTime date = DateTime.now().add(Duration(days: random.nextInt(30)));
    final String location = faker.address.city();
    final double price = (random.nextDouble() * 100).roundToDouble();
    final List<String> comments = List.generate(
      10,
          (index) => faker.lorem.sentence(),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar с кнопкой назад и кнопкой like
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(eventName),
              background: flutter.Image.network(
                imageUrls.isNotEmpty ? imageUrls[0] : '',
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // Логика добавления в избранное
                },
              ),
            ],
          ),
          // Содержимое экрана
          SliverList(
            delegate: SliverChildListDelegate([
              // Название события
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  eventName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Картинки в LazyRow
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: flutter.Image.network(imageUrls[index]),
                    );
                  },
                ),
              ),
              // Оценка и количество звезд
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
              // Описание события
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Дата, место и цена
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Дата: ${date.toLocal()}'.split(' ')[0]),
                    const SizedBox(height: 8),
                    Text('Место: $location'),
                    const SizedBox(height: 8),
                    Text('Цена: \$$price'),
                  ],
                ),
              ),
              // Кнопка "Купить"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Логика покупки билета
                  },
                  child: const Text('Купить'),
                ),
              ),

              // Секция комментариев
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Комментарии',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...comments.map((comment) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(comment),
              )),
              // Поле ввода комментария
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Напишите комментарий...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        // Логика отправки комментария
                      },
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
