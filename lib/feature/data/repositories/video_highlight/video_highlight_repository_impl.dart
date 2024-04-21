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
import '../../../domain/entities/video_highlight/video_highlight.dart';
import '../../../domain/repositories/video_highlight/video_highlight_repository.dart';
import '../../data_sources/video_highlight/video_highlight_request.dart';
import '../../data_sources/video_highlight/video_highlight_service.dart';

class VideoHighlightRepositoryImpl implements VideoHighlightRepository {
  final VideoHighlightApiService _videoHighlightApiService;
  VideoHighlightRepositoryImpl(this._videoHighlightApiService);

  @override
  Future<DataState<VideoHighlightEntity>> getVideoHighlight({required VideoHighlightRequestBody body}) async {
    try{
      final httpResponse = await _videoHighlightApiService.videoHighlight(body);
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