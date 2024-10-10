class Event {
  final String imageUrl;
  final String description;
  final double? rating; // Может быть null, если рейтинг не указан
  final int commentCount;
  final DateTime date;

  Event({
    required this.imageUrl,
    required this.description,
    this.rating,
    required this.commentCount,
    required this.date,
  });
}
