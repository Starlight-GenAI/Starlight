import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:starlight/feature/data/data_sources/upload_video/upload_video_service.dart';
import 'package:starlight/feature/data/data_sources/youtube/youtube_api_service.dart';
import 'package:starlight/feature/data/repositories/upload_video/upload_video_repository.dart';
import 'package:starlight/feature/data/repositories/youtube_search_repository_implement.dart';
import 'package:starlight/feature/domain/repositories/upload_video/upload_video_repository.dart';
import 'package:starlight/feature/domain/repositories/youtube_repository.dart';
import 'package:starlight/feature/domain/use_cases/get_youtube_search.dart';
import 'package:starlight/feature/domain/use_cases/upload_video/upload_video.dart';
import 'package:starlight/feature/presentation/manager/home/home_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_bloc.dart';
final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  sl.registerSingleton<Dio>(Dio());

  sl.registerSingleton<YoutubeApiService>(YoutubeApiService(sl()));
  
  sl.registerSingleton<YoutubeRepository>(
    YoutubeRepositoryImpl(sl())
  );

  sl.registerSingleton<GetYoutubeSearchUseCase>(
    GetYoutubeSearchUseCase(sl())
  );

  sl.registerFactory<HomeBloc>(
      () => HomeBloc(sl())
  );

  sl.registerSingleton<UploadVideoApiService>(UploadVideoApiService(sl()));

  sl.registerSingleton<UploadVideoRepository>(
      UploadVideoRepositoryImpl(sl())
  );

  sl.registerSingleton<UploadVideoUseCase>(
      UploadVideoUseCase(sl())
  );

  sl.registerFactory<JourneyPlannerBloc>(
      () => JourneyPlannerBloc(sl(),sl())
  );
}