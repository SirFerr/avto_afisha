import 'package:avto_afisha/feature/screens/main_screen/home/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'blocs/event_bloc.dart';
import 'blocs/search_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearchOpen = false; // Search input visibility
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    setState(() {
      if (_isSearchOpen && _searchController.text.isNotEmpty) {
        context.read<SearchBloc>().add(SearchQueryChanged(_searchController.text));
      } else if (_isSearchOpen && _searchController.text.isEmpty) {
        _isSearchOpen = false; // Close the search field
      } else {
        _isSearchOpen = true; // Open the search field
      }
    });
  }

  void _closeSearch() {
    setState(() {
      _isSearchOpen = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => EventBloc(httpClient: http.Client())..add(LoadEvents())),
        BlocProvider(create: (_) => SearchBloc(httpClient: http.Client())),
      ],
      child: GestureDetector(
        onTap: _closeSearch, // Close search input when clicking outside
        child: Scaffold(
          appBar: AppBar(
            title: _isSearchOpen
                ? TextField(
              controller: _searchController,
              autofocus: true,
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  context.read<SearchBloc>().add(SearchQueryChanged(query));
                } else {
                  _closeSearch();
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            )
                : const Text('Exhibitions'),
            actions: [
              IconButton(
                icon: Icon(_isSearchOpen ? Icons.check : Icons.search),
                onPressed: _toggleSearch,
              ),
            ],
          ),
          body: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchLoaded) {
                final exhibitions = state.exhibitions;
                return exhibitions.isNotEmpty
                    ? ListView.builder(
                  itemCount: exhibitions.length,
                  itemBuilder: (context, index) {
                    return EventCard(exhibition: exhibitions[index]);
                  },
                )
                    : const Center(child: Text('No results found.'));
              } else if (state is SearchError) {
                return Center(child: Text('Error: ${state.error}'));
              }
              return BlocBuilder<EventBloc, EventState>(
                builder: (context, state) {
                  if (state is EventLoading || state is EventInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EventLoaded) {
                    return ListView.builder(
                      itemCount: state.exhibitions.length,
                      itemBuilder: (context, index) {
                        return EventCard(exhibition: state.exhibitions[index]);
                      },
                    );
                  }
                  return const SizedBox();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
