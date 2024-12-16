import 'package:avto_afisha/constans/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../models/exhibition_model.dart';

// Event Events
abstract class EventEvent {}

class LoadEvents extends EventEvent {}

// Event States
abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<Exhibition> exhibitions;
  EventLoaded(this.exhibitions);
}

class EventError extends EventState {
  final String error;
  EventError(this.error);
}

class EventBloc extends Bloc<EventEvent, EventState> {
  final http.Client httpClient;

  EventBloc({required this.httpClient}) : super(EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final response = await httpClient.get(Uri.parse('$API/api/exhibitions'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final exhibitions = data.map((e) => Exhibition.fromJson(e)).toList();
        emit(EventLoaded(exhibitions));
      } else {
        emit(EventError('Failed to load events: ${response.reasonPhrase}'));
      }
    } catch (e) {
      emit(EventError('Failed to load events: $e'));
    }
  }
}
