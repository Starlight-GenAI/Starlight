import 'package:dio/dio.dart';
import 'package:starlight/core/resources/data_state.dart';
import 'package:starlight/feature/presentation/manager/home/home_event.dart';
import 'package:starlight/feature/presentation/manager/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/get_youtube_search.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetYoutubeSearchUseCase _getYoutubeSearchUseCase;

  HomeBloc(this._getYoutubeSearchUseCase) : super(const HomeLoadingState()) {
    on<YoutubeSearch>(_onYoutubeSearch);
  }

  void _onYoutubeSearch(YoutubeSearch event, Emitter<HomeState> emit) async {
    // Dispatch a loading state to indicate that the search is in progress
    emit(const HomeLoadingState());

    try {
      final dataState = await _getYoutubeSearchUseCase(params: event.word);
      if (dataState is DataSuccess) {
        // Emit a loaded state with the obtained data
        emit(HomeLoadedState(dataState.data!));
      } else if (dataState is DataFailed) {
        // Emit an error state if data retrieval fails
        emit(HomeErrorState(dataState.error!));
      }
    } catch (e) {
      // Emit an error state if an exception occurs during data retrieval
      emit(HomeErrorState(DioException(error: e.toString(), requestOptions: RequestOptions())));
    }
  }

}
