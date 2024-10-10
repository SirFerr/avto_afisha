class Event {
  final String eventName;
  final String description;
  final String imageUrl;
  final double? rating;
  final DateTime date;
  final String location;
  final double price;
  final List<String> comments;

  Event({
    required this.eventName,
    required this.description,
    required this.imageUrl,
    this.rating,
    required this.date,
    required this.location,
    required this.price,
    required this.comments,
  });
}
