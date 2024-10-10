import 'package:flutter/material.dart';
import 'widgets/event_appbar.dart';
import 'widgets/event_details.dart';
import 'widgets/event_comments.dart';

class EventScreen extends StatelessWidget {
  final String eventName;
  final String description;
  final List<String> imageUrls;
  final double rating;
  final DateTime date;
  final String location;
  final double price;
  final List<String> comments;

  const EventScreen({
    super.key,
    required this.eventName,
    required this.description,
    required this.imageUrls,
    required this.rating,
    required this.date,
    required this.location,
    required this.price,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          EventAppBar(
            eventName: eventName,
            imageUrl: imageUrls.isNotEmpty ? imageUrls[0] : '',
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              EventDetails(
                eventName: eventName,
                description: description,
                imageUrls: imageUrls,
                rating: rating,
                date: date,
                location: location,
                price: price,
              ),
              EventComments(comments: comments),
            ]),
          ),
        ],
      ),
    );
  }
}
