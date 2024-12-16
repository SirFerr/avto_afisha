class Exhibition {
  final String id;
  final String name;
  final String description;
  final String location;
  final String date;
  final String time;
  final String price;
  final String image;
  final double rating;

  Exhibition({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    required this.price,
    required this.image,
    required this.rating,
  });

  factory Exhibition.fromJson(Map<String, dynamic> json) {
    return Exhibition(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      date: json['date'],
      time: json['time'],
      price: json['price'],
      image: json['image'],
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'date': date,
      'time': time,
      'price': price,
      'image': image,
      'rating': rating,
    };
  }
}
