import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'blocs/favorite_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          FavoriteBloc(httpClient: http.Client())..add(LoadFavorites()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Избранные мероприятия'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteInitial || state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoriteLoaded) {
              final exhibitions = state.exhibitions;
              if (exhibitions.isEmpty) {
                return const Center(child: Text('No favorite exhibitions'));
              }
              return ListView.builder(
                itemCount: exhibitions.length,
                itemBuilder: (context, index) {
                  final exhibition = exhibitions[index];
                  return GestureDetector(
                    onTap: () {
                      context.push('/event/${exhibition.id}');
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exhibition.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Дата: ${exhibition.date}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Место: ${exhibition.location}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is FavoriteError) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
