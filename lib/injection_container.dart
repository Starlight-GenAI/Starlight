import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:starlight/feature/data/data_sources/list_history/list_history_service.dart';
import 'package:starlight/feature/data/data_sources/trip_planner/trip_planner_service.dart';
import 'package:starlight/feature/data/data_sources/upload_video/upload_video_service.dart';
import 'package:starlight/feature/data/data_sources/video_detail/video_detail_service.dart';
import 'package:starlight/feature/data/data_sources/video_highlight/video_highlight_service.dart';
import 'package:starlight/feature/data/data_sources/video_summary/video_summary_service.dart';
import 'package:starlight/feature/data/data_sources/youtube/youtube_api_service.dart';
import 'package:starlight/feature/data/repositories/list_history/list_history_repository_implement.dart';
import 'package:starlight/feature/data/repositories/trip_planner/trip_planner_repository_impl.dart';
import 'package:starlight/feature/data/repositories/upload_video/upload_video_repository.dart';
import 'package:starlight/feature/data/repositories/video_detail/video_detail_repository.dart';
import 'package:starlight/feature/data/repositories/video_highlight/video_highlight_repository_impl.dart';
import 'package:starlight/feature/data/repositories/youtube/youtube_search_repository_implement.dart';
import 'package:starlight/feature/domain/repositories/list_history/list_history_repository.dart';
import 'package:starlight/feature/domain/repositories/trip_planner/trip_planner_repository.dart';
import 'package:starlight/feature/domain/repositories/upload_video/upload_video_repository.dart';
import 'package:starlight/feature/domain/repositories/video_detail/video_detail_repository.dart';
import 'package:starlight/feature/domain/repositories/video_highlight/video_highlight_repository.dart';
import 'package:starlight/feature/domain/repositories/video_summary/video_summary_repository.dart';
import 'package:starlight/feature/domain/repositories/youtube/youtube_repository.dart';
import 'package:starlight/feature/domain/use_cases/trip_planner/trip_planner.dart';
import 'package:starlight/feature/domain/use_cases/video_highlight/video-highlight.dart';
import 'package:starlight/feature/domain/use_cases/youtube/get_youtube_search.dart';
import 'package:starlight/feature/domain/use_cases/list_history/list_history.dart';
import 'package:starlight/feature/domain/use_cases/upload_video/upload_video.dart';
import 'package:starlight/feature/domain/use_cases/video_detail/video_detail.dart';
import 'package:starlight/feature/domain/use_cases/video_summary/video_summary.dart';
import 'package:starlight/feature/presentation/manager/home/home_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_highlight/journey_highlight_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_summary/journey_summary_bloc.dart';
import 'package:starlight/feature/presentation/manager/list_history/list_history_bloc.dart';
import 'package:starlight/feature/presentation/manager/trip_planner/trip_planner_bloc.dart';
import 'package:starlight/feature/presentation/pages/list_history/list_history_page.dart';

import 'feature/data/repositories/video_summary/video_summary_repository_impl.dart';
final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  sl.registerSingleton<Dio>(Dio());

  sl.registerSingleton<YoutubeApiService>(YoutubeApiService(sl()));
  sl.registerSingleton<YoutubeRepository>(YoutubeRepositoryImpl(sl()));
  sl.registerSingleton<GetYoutubeSearchUseCase>(GetYoutubeSearchUseCase(sl()));
  sl.registerFactory<HomeBloc>(() => HomeBloc(sl()));

  sl.registerSingleton<UploadVideoApiService>(UploadVideoApiService(sl()));
  sl.registerSingleton<UploadVideoRepository>(UploadVideoRepositoryImpl(sl()));
  sl.registerSingleton<UploadVideoUseCase>(UploadVideoUseCase(sl()));

  sl.registerSingleton<VideoDetailApiService>(VideoDetailApiService(sl()));
  sl.registerSingleton<VideoDetailRepository>(VideoDetailRepositoryImpl(sl()));
  sl.registerSingleton<VideoDetailUseCase>(VideoDetailUseCase(sl()));
  sl.registerFactory<JourneyPlannerBloc>(() => JourneyPlannerBloc(sl(),sl()));

  sl.registerSingleton<VideoSummaryService>(VideoSummaryService(sl()));
  sl.registerSingleton<VideoSummaryRepository>(VideoSummaryRepositoryImpl(sl()));
  sl.registerSingleton<VideoSummaryUseCase>(VideoSummaryUseCase(sl()));
  sl.registerFactory<JourneySummaryBloc>(() => JourneySummaryBloc(sl()));

  sl.registerSingleton<ListHistoryApiService>(ListHistoryApiService(sl()));
  sl.registerSingleton<ListHistoryRepository>(ListHistoryRepositoryImpl(sl()));
  sl.registerSingleton<ListHistoryUseCase>(ListHistoryUseCase(sl()));
  sl.registerFactory<ListHistoryBloc>(() => ListHistoryBloc(sl()));

  sl.registerSingleton<VideoHighlightApiService>(VideoHighlightApiService(sl()));
  sl.registerSingleton<VideoHighlightRepository>(VideoHighlightRepositoryImpl(sl()));
  sl.registerSingleton<VideoHighlightUseCase>(VideoHighlightUseCase(sl()));
  sl.registerFactory<JourneyHighlightBloc>(() => JourneyHighlightBloc(sl()));

  sl.registerSingleton<TripPlannerApiService>(TripPlannerApiService(sl()));
  sl.registerSingleton<TripPlannerRepository>(TripPlannerRepositoryImpl(sl()));
  sl.registerSingleton<TripPlannerUseCase>(TripPlannerUseCase(sl()));
  sl.registerFactory<TripPlannerBloc>(() => TripPlannerBloc(sl()));
}