import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'blocs/event_bloc.dart';
import '../../../models/exhibition_model.dart';
import 'widgets/event_appbar.dart';
import 'widgets/event_details.dart';
import 'widgets/event_comments.dart';

class EventScreen extends StatelessWidget {
  final Exhibition exhibition;

  const EventScreen({super.key, required this.exhibition});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventBloc(httpClient: http.Client())..add(LoadEventDetails(exhibition.id)),
      child: Scaffold(
        body: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is EventLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventLoaded) {
              final exhibition = state.exhibition;
              return CustomScrollView(
                slivers: [
                  EventAppBar(
                    exhibition: exhibition,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      EventDetails(
                       exhibition: exhibition,
                      ),
                      // EventComments(comments: exhibition ?? []),
                    ]),
                  ),
                ],
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
