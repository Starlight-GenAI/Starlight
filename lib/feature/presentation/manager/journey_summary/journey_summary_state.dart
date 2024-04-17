import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starlight/feature/domain/entities/video_summary/video_summary.dart';

abstract class JourneySummaryState extends Equatable{
  final VideoSummaryEntity? list;
  final DioException? error;

  const JourneySummaryState({this.list, this.error});

  @override
  List<Object?> get props => [list, error];
}

class VideoSummaryLoadingState extends JourneySummaryState {
  const VideoSummaryLoadingState();

}

class VideoSummaryLoadedState extends JourneySummaryState {
  const VideoSummaryLoadedState(VideoSummaryEntity list) : super(list: list);
}

class VideoSummaryErrorState extends JourneySummaryState {
  const VideoSummaryErrorState(DioException error) : super(error: error);
}
