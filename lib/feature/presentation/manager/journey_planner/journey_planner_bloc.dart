import 'package:dio/dio.dart';
import 'package:starlight/core/resources/data_state.dart';
import 'package:starlight/feature/data/data_sources/upload_video/upload_video_request.dart';
import 'package:starlight/feature/data/data_sources/video_detail/video_detail_request.dart';
import 'package:starlight/feature/domain/use_cases/upload_video/upload_video.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight/feature/domain/use_cases/video_detail/video_detail.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_event.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_state.dart';

import '../../../domain/use_cases/youtube/get_youtube_search.dart';

class JourneyPlannerBloc extends Bloc<JourneyPlannerEvent,JourneyPlannerState>{
  final UploadVideoUseCase _uploadVideoUseCase;
  final VideoDetailUseCase _videoDetailUseCase;

  JourneyPlannerBloc(this._uploadVideoUseCase, this._videoDetailUseCase): super(const UploadVideoLoadingState()) {
    on <UploadVideo> (onUploadVideo);
    on <VideoDetail> (onGetVideoDetail);
    // on <ResetBlocEvent>((event, emit){
    //   emit(const UploadVideoLoadingState());
    // });
  }

  void onUploadVideo(UploadVideo uploadVideo, Emitter<JourneyPlannerState> emit) async{
    emit(const UploadVideoLoadingState());

    final dataState = await _uploadVideoUseCase(params:  VideoRequestBody(
        videoUrl: uploadVideo.videoUrl!,
        isUseSubtitle: uploadVideo.isUseSubtitle,
        userId: uploadVideo.userId,
        videoId: uploadVideo.videoId!,
        prompt: uploadVideo.prompt != null ? uploadVideo.prompt! : '',
        promptPreset: uploadVideo.promptPreset != null ? uploadVideo.promptPreset! :
        PromptPresetRequestBody(day: 1, city: '', journeyType: '', interestingActivity: '')
    ));
    print('/////////////////state data/////////////////');
    print(dataState);

    if (dataState is DataSuccess && dataState.data != null) {
      final uploadedData = dataState.data!;
      emit(UploadVideoLoadedState(uploadedData));
    } else if (dataState is DataFailed) {
      print(dataState.error!.response);
      emit(UploadVideoErrorState(dataState.error!));
    }
  }

  void onGetVideoDetail(VideoDetail videoDetail, Emitter<JourneyPlannerState> emit) async{
    emit(const VideoDetailLoadingState());
    final dataState = await _videoDetailUseCase(params: VideoDetailRequestBody(videoId: videoDetail.videoId));
    print('/////////////////state detail data/////////////////');
    print(dataState);

    if (dataState is DataSuccess && dataState.data != null) {
      final uploadedData = dataState.data!;
      emit(VideoDetailLoadedState(uploadedData));
    } else if (dataState is DataFailed) {
      print(dataState.error!.response);
      emit(VideoDetailErrorState(dataState.error!));
    }

  }
  @override
  Stream<JourneyPlannerState> mapEventToState(JourneyPlannerEvent event) async* {
    if (event is ResetBlocEvent) {
      yield const VideoDetailLoadingState();
    }
  }

}
