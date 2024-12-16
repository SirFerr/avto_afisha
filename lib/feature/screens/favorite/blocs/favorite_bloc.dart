import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../constans/constants.dart';
import '../../../../models/exhibition_model.dart';

// Events
abstract class FavoriteEvent {}

class LoadFavorites extends FavoriteEvent {}

// States
abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Exhibition> exhibitions;

  FavoriteLoaded(this.exhibitions);
}

class FavoriteError extends FavoriteState {
  final String error;

  FavoriteError(this.error);
}

// BLoC
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final http.Client httpClient;

  FavoriteBloc({required this.httpClient}) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final response = await httpClient.get(
        Uri.parse('$API/api/exhibitions'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final exhibitions = data.map((e) => Exhibition.fromJson(e)).toList();
        emit(FavoriteLoaded(exhibitions));
      } else {
        emit(FavoriteError('Failed to load favorites: ${response.reasonPhrase}'));
      }
    } catch (e) {
      emit(FavoriteError('Failed to load favorites: $e'));
    }
  }
}
