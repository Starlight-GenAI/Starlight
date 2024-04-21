import 'dart:io';

import 'package:dio/dio.dart';
import 'package:starlight/core/constants/constants.dart';
import 'package:starlight/feature/data/data_sources/video_summary/video_summary_request.dart';
import 'package:starlight/feature/data/data_sources/video_summary/video_summary_service.dart';
import 'package:starlight/feature/data/data_sources/youtube/youtube_api_service.dart';
import 'package:starlight/feature/data/models/upload_video/upload_video.dart';
import 'package:starlight/feature/data/models/youtube/youtube_search.dart';
import 'package:starlight/feature/domain/entities/video_summary/video_summary.dart';
import 'package:starlight/feature/domain/repositories/video_summary/video_summary_repository.dart';
import 'package:starlight/feature/domain/repositories/youtube/youtube_repository.dart';

import '../../../../core/resources/data_state.dart';

class VideoSummaryRepositoryImpl implements VideoSummaryRepository {
  final VideoSummaryService _videoSummaryService;
  VideoSummaryRepositoryImpl(this._videoSummaryService);

  @override
  Future<DataState<VideoSummaryEntity>> getVideoSummary({required VideoSummaryRequestBody body}) async {
    try{
      final httpResponse = await _videoSummaryService.getVideoSummary(body);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions));
      }
    } on DioException catch (e){
      print(e);
      return DataFailed(e);
    }
  }
}