import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_config.dart';
import '../providers/places_notifier.dart';
import '../widgets/place_tile.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _onFavoritesPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const FavoritesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<PlacesNotifier>();
    final places = notifier.places;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConfig.appTitle),
        actions: [
          IconButton(
            tooltip: 'Обране',
            onPressed: () => _onFavoritesPressed(context),
            icon: Badge(
              isLabelVisible: notifier.favorites.isNotEmpty,
              label: Text('${notifier.favorites.length}'),
              child: const Icon(Icons.favorite),
            ),
          ),
        ],
      ),
      body: notifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];

                return PlaceTile(
                  place: place,
                  isFavorite: notifier.isFavorite(place.id),
                  onFavoritePressed: () => context
                      .read<PlacesNotifier>()
                      .toggleFavorite(place.id),
                );
              },
            ),
    );
  }
}
