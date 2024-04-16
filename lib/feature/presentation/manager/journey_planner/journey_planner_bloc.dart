import 'package:dio/dio.dart';
import 'package:starlight/core/resources/data_state.dart';
import 'package:starlight/feature/data/data_sources/upload_video/upload_video_request.dart';
import 'package:starlight/feature/data/data_sources/video_detail/video_detail_request.dart';
import 'package:starlight/feature/domain/use_cases/upload_video/upload_video.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight/feature/domain/use_cases/video_detail/video_detail.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_event.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_state.dart';

import '../../../domain/use_cases/get_youtube_search.dart';

class JourneyPlannerBloc extends Bloc<JourneyPlannerEvent,JourneyPlannerState>{
  final UploadVideoUseCase _uploadVideoUseCase;
  final VideoDetailUseCase _videoDetailUseCase;

  JourneyPlannerBloc(this._uploadVideoUseCase, this._videoDetailUseCase): super(const VideoDetailLoadingState()) {
    on <UploadVideo> (onUploadVideo);
    on <VideoDetail> (onGetVideoDetail);
  }

  void onUploadVideo(UploadVideo uploadVideo, Emitter<JourneyPlannerState> emit) async{
    final dataState = await _uploadVideoUseCase(params: VideoRequestBody(videoUrl: uploadVideo.videoUrl, isUseSubtitle: uploadVideo.isUseSubtitle, userId: uploadVideo.userId));
    print('/////////////////state data/////////////////');
    print(dataState.data!);

    if (dataState is DataSuccess && dataState.data != null) {
      final uploadedData = dataState.data!;
      emit(UploadVideoLoadedState(uploadedData));
      print('Successfully uploaded video data: $uploadedData');
    } else if (dataState is DataFailed) {
      print(dataState.error!.response);
      emit(UploadVideoErrorState(dataState.error!));
    }
  }

  void onGetVideoDetail(VideoDetail videoDetail, Emitter<JourneyPlannerState> emit) async{
    final dataState = await _videoDetailUseCase(params: VideoDetailRequestBody(videoUrl: videoDetail.videoUrl));
    print('/////////////////state detail data/////////////////');
    print(dataState);

    if (dataState is DataSuccess && dataState.data != null) {
      final uploadedData = dataState.data!;
      emit(VideoDetailLoadedState(uploadedData));
      print('Successfully video detail data: $uploadedData');
    } else if (dataState is DataFailed) {
      print(dataState.error!.response);
      emit(VideoDetailErrorState(dataState.error!));
    }
  }

}