class Place {
  final String id;
  final String name;
  final String description;
  final double rating;

  const Place({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
  }) : assert(rating >= 0 && rating <= 5, 'Рейтинг має бути від 0 до 5');

  @override
  bool operator ==(Object other) => other is Place && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
