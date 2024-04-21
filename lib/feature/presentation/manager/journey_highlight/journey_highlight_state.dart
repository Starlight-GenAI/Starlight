
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starlight/feature/domain/entities/video_highlight/video_highlight.dart';

import '../../../domain/entities/list_history/list_history.dart';

abstract class JourneyHighlightState extends Equatable{
  final VideoHighlightEntity? list;
  final DioException? error;

  const JourneyHighlightState({this.list, this.error});

  @override
  List<Object?> get props => [list, error];
}

class JourneyHighlightLoadingState extends JourneyHighlightState {
  const JourneyHighlightLoadingState();

}

class JourneyHighlightLoadedState extends JourneyHighlightState {
  const JourneyHighlightLoadedState(VideoHighlightEntity list) : super(list: list);
}

class JourneyHighlightErrorState extends JourneyHighlightState {
  const JourneyHighlightErrorState(DioException error) : super(error: error);
}
