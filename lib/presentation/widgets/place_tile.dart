import 'package:flutter/material.dart';

import '../../domain/entities/place.dart';

class PlaceTile extends StatelessWidget {
  final Place place;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const PlaceTile({
    super.key,
    required this.place,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(place.name),
        subtitle: Text(place.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 18),
            const SizedBox(width: 4),
            Text(place.rating.toString()),
            IconButton(
              key: Key('favorite_button_${place.id}'),
              tooltip: isFavorite ? 'Прибрати з обраного' : 'Додати в обране',
              onPressed: onFavoritePressed,
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
          ],
        ),
      ),
    );
  }
}
