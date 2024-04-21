
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight/feature/data/data_sources/video_highlight/video_highlight_request.dart';
import 'package:starlight/feature/domain/use_cases/list_history/list_history.dart';
import 'package:starlight/feature/domain/use_cases/video_highlight/video-highlight.dart';
import 'package:starlight/feature/presentation/manager/journey_highlight/journey_highlight_event.dart';

import '../../../../core/resources/data_state.dart';
import '../../../data/data_sources/list_history/list_history_request.dart';
import 'journey_highlight_state.dart';

class JourneyHighlightBloc extends Bloc<JourneyHighlightEvent, JourneyHighlightState> {
  final VideoHighlightUseCase _getVideoHighlightUseCase;

  JourneyHighlightBloc( this._getVideoHighlightUseCase) : super(const JourneyHighlightLoadingState()) {
    on<GetHighlight>(_onGetHighlight);
  }

  void _onGetHighlight(GetHighlight event, Emitter<JourneyHighlightState> emit) async {
    emit(const JourneyHighlightLoadingState());

    try {
      emit(const JourneyHighlightLoadingState());
      final dataState = await _getVideoHighlightUseCase(params: VideoHighlightRequestBody( id: event.Id));
      if (dataState is DataSuccess) {
        print('leo 122');
        print(dataState.data!.content[0].highlightName);
        emit(JourneyHighlightLoadedState(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(JourneyHighlightErrorState(dataState.error!));
      }
    } catch (e) {
      print('fail 2');

      emit(JourneyHighlightErrorState(DioException(error: e.toString(), requestOptions: RequestOptions())));
    }
  }

}
