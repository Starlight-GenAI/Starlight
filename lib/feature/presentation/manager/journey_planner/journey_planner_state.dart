import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:starlight/feature/domain/entities/upload_video/upload_video.dart';

import '../../../domain/entities/youtube_search.dart';

abstract class JourneyPlannerState extends Equatable{
  final QueueIdEntity ? list;
  final DioException ? error;

  const JourneyPlannerState({this.list, this.error});

  @override
  List<Object> get props => [list!, error!];
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