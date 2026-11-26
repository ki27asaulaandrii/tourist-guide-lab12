import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places_notifier.dart';
import '../widgets/place_tile.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<PlacesNotifier>().favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Обране')),
      body: favorites.isEmpty
          ? const Center(child: Text('Обраних місць немає'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final place = favorites[index];

                return PlaceTile(
                  place: place,
                  isFavorite: true,
                  onFavoritePressed: () => context
                      .read<PlacesNotifier>()
                      .toggleFavorite(place.id),
                );
              },
            ),
    );
  }
}
