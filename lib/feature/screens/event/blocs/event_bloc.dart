import 'package:avto_afisha/constans/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../models/exhibition_model.dart';

// Events
abstract class EventEvent {}

class LoadEventDetails extends EventEvent {
  final String id;
  LoadEventDetails(this.id);
}

// States
abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final Exhibition exhibition;
  EventLoaded(this.exhibition);
}

class EventError extends EventState {
  final String error;
  EventError(this.error);
}

// BLoC
class EventBloc extends Bloc<EventEvent, EventState> {
  final http.Client httpClient;

  EventBloc({required this.httpClient}) : super(EventInitial()) {
    on<LoadEventDetails>(_onLoadEventDetails);
  }

  Future<void> _onLoadEventDetails(
      LoadEventDetails event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final response = await httpClient.get(
        Uri.parse('$API/api/exhibitions/${event.id}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final exhibition = Exhibition.fromJson(data);
        emit(EventLoaded(exhibition));
      } else {
        emit(EventError('Failed to load event: ${response.reasonPhrase}'));
      }
    } catch (e) {
      emit(EventError('Failed to load event: $e'));
    }
  }
}
