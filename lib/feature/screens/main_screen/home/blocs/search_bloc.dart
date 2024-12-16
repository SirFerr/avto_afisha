import 'package:avto_afisha/constans/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../models/exhibition_model.dart';

// Search Events
abstract class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
}

// Search States
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Exhibition> exhibitions;
  SearchLoaded(this.exhibitions);
}

class SearchError extends SearchState {
  final String error;
  SearchError(this.error);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final http.Client httpClient;

  SearchBloc({required this.httpClient}) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  Future<void> _onSearchQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final response = await httpClient.get(Uri.parse('$API/api/exhibitions?search=${event.query}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final exhibitions = data.map((e) => Exhibition.fromJson(e)).toList();
        emit(SearchLoaded(exhibitions));
      } else {
        emit(SearchError('Failed to search events: ${response.reasonPhrase}'));
      }
    } catch (e) {
      emit(SearchError('Failed to search events: $e'));
    }
  }
}
