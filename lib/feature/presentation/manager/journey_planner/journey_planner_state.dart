import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starlight/feature/domain/entities/upload_video/upload_video.dart';
import 'package:starlight/feature/domain/entities/video_detail/video_detail.dart';

import '../../../domain/entities/youtube_search.dart';
import 'journey_planner_event.dart';

abstract class JourneyPlannerState extends Equatable{
  final QueueIdEntity? list;
  final VideoDetailEntity? listDetail;
  final DioException? error;

  const JourneyPlannerState({this.list, this.listDetail, this.error});

  @override
  List<Object?> get props => [list, listDetail, error];
}


class UploadVideoLoadingState extends JourneyPlannerState {
  const UploadVideoLoadingState();

}

class UploadVideoLoadedState extends JourneyPlannerState {
  const UploadVideoLoadedState(QueueIdEntity list) : super(list: list);
}

class UploadVideoErrorState extends JourneyPlannerState {
  const UploadVideoErrorState(DioException error) : super(error: error);
}

class VideoDetailLoadingState extends JourneyPlannerState {
  const VideoDetailLoadingState();

}

class VideoDetailLoadedState extends JourneyPlannerState {
  const VideoDetailLoadedState(VideoDetailEntity listDetail) : super(listDetail: listDetail);
}

class VideoDetailErrorState extends JourneyPlannerState {
  const VideoDetailErrorState(DioException error) : super(error: error);
}

class ResetBlocEvent extends JourneyPlannerEvent {}