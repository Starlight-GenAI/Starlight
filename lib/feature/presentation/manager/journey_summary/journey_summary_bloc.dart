
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight/feature/data/data_sources/video_summary/video_summary_request.dart';
import 'package:starlight/feature/presentation/manager/journey_summary/journey_summary_event.dart';
import 'package:starlight/feature/presentation/manager/journey_summary/journey_summary_state.dart';

import '../../../../core/resources/data_state.dart';
import '../../../domain/use_cases/video_summary/video_summary.dart';

class JourneySummaryBloc extends Bloc<JourneySummaryEvent, JourneySummaryState> {
  final VideoSummaryUseCase _getVideoSummaryUseCase;

  JourneySummaryBloc( this._getVideoSummaryUseCase) : super(const VideoSummaryLoadingState()) {
    on<GetSummaryVideo>(_onGetSummaryVideo);
  }

  void _onGetSummaryVideo(GetSummaryVideo event, Emitter<JourneySummaryState> emit) async {
    emit(const VideoSummaryLoadingState());

    try {
      final dataState = await _getVideoSummaryUseCase(params: VideoSummaryRequestBody( id: event.id));
      if (dataState is DataSuccess) {
        // Emit a loaded state with the obtained data
        emit(VideoSummaryLoadedState(dataState.data!));
      } else if (dataState is DataFailed) {
        // Emit an error state if data retrieval fails
        emit(VideoSummaryErrorState(dataState.error!));
      }
    } catch (e) {
      // Emit an error state if an exception occurs during data retrieval
      emit(VideoSummaryErrorState(DioException(error: e.toString(), requestOptions: RequestOptions())));
    }
  }

}
