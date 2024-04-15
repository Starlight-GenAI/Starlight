import 'package:starlight/core/resources/data_state.dart';
import 'package:starlight/feature/domain/use_cases/upload_video/upload_video.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_event.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_state.dart';

import '../../../domain/use_cases/get_youtube_search.dart';

class JourneyPlannerBloc extends Bloc<JourneyPlannerEvent,JourneyPlannerState>{
  final UploadVideoUseCase _uploadVideoUseCase;
  JourneyPlannerBloc(this._uploadVideoUseCase): super(const UploadVideoLoadingState()){
    on <UploadVideo> (onUploadVideo);
  }

  void onUploadVideo(UploadVideo uploadVideo, Emitter<JourneyPlannerState> emit) async{
    final dataState = await _uploadVideoUseCase();

    if(dataState is DataSuccess && dataState.data != null){
      emit(
          UploadVideoLoadedState(dataState.data!)
      );
    }

    if(dataState is DataFailed){
      print(dataState.error!.response);

      emit(
          UploadVideoErrorState(dataState.error!)
      );
    }
  }

}