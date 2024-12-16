import 'package:avto_afisha/feature/screens/main_screen/home/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'blocs/event_bloc.dart';
import 'blocs/search_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => EventBloc(httpClient: http.Client())..add(LoadEvents())),
        BlocProvider(create: (_) => SearchBloc(httpClient: http.Client())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exhibitions'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ExhibitionSearchDelegate(
                    searchBloc: context.read<SearchBloc>(),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is EventInitial || state is EventLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventLoaded) {
              return ListView.builder(
                itemCount: state.exhibitions.length,
                itemBuilder: (context, index) {
                  return EventCard(exhibition: state.exhibitions[index]);
                },
              );
            } else if (state is EventError) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class ExhibitionSearchDelegate extends SearchDelegate {
  final SearchBloc searchBloc;

  ExhibitionSearchDelegate({required this.searchBloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchBloc.add(SearchQueryChanged(query));
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchBloc.add(SearchQueryChanged(query));

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchLoaded) {
          final exhibitions = state.exhibitions;
          if (exhibitions.isEmpty) {
            return const Center(child: Text('No exhibitions found'));
          }
          return ListView.builder(
            itemCount: exhibitions.length,
            itemBuilder: (context, index) {
              return EventCard(exhibition: exhibitions[index]);
            },
          );
        } else if (state is SearchError) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return const Center(child: Text('Start typing to search'));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchBloc.add(SearchQueryChanged(query));

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchLoaded) {
          final exhibitions = state.exhibitions;
          return ListView.builder(
            itemCount: exhibitions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(exhibitions[index].name),
                onTap: () {
                  query = exhibitions[index].name;
                  showResults(context);
                },
              );
            },
          );
        } else if (state is SearchError) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return const Center(child: Text('Start typing to search'));
      },
    );
  }
}
