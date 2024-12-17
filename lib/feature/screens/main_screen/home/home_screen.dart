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
  bool _isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    setState(() {
      _isSearchOpen = !_isSearchOpen;
      if (_searchController.text.isNotEmpty) {
        context.read<SearchBloc>().add(SearchQueryChanged(_searchController.text));
      }
    });
  }

  void _closeSearch() {
    setState(() {
      if(_searchController.text == "" || _searchController.text == ""){
        _isSearchOpen = false;
        _searchController.clear();
      }// Reload events when search closes
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
              if (_isSearchOpen)
              IconButton(
                icon: const Icon(Icons.cancel_outlined),
                onPressed: _searchController.clear,
              ),
              IconButton(
                icon: Icon(_isSearchOpen ? Icons.check : Icons.search),
                onPressed: _toggleSearch,
              ),
            ],
          ),
          body: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, searchState) {
              if (searchState is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (searchState is SearchLoaded) {
                // Replace results with the search list
                final exhibitions = searchState.exhibitions;
                return exhibitions.isNotEmpty
                    ? ListView.builder(
                  itemCount: exhibitions.length,
                  itemBuilder: (context, index) {
                    return EventCard(exhibition: exhibitions[index]);
                  },
                )
                    : const Center(child: Text('No search results found.'));
              } else if (searchState is SearchError) {
                return Center(child: Text('Error: ${searchState.error}'));
              }

              // Default fallback to EventBloc
              return BlocBuilder<EventBloc, EventState>(
                builder: (context, eventState) {
                  if (eventState is EventLoading || eventState is EventInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (eventState is EventLoaded) {
                    return ListView.builder(
                      itemCount: eventState.exhibitions.length,
                      itemBuilder: (context, index) {
                        return EventCard(exhibition: eventState.exhibitions[index]);
                      },
                    );
                  } else if (eventState is EventError) {
                    return Center(child: Text('Error: ${eventState.error}'));
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
