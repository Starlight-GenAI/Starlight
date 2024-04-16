import 'dart:io';

import 'package:dio/dio.dart';
import 'package:starlight/core/constants/constants.dart';
import 'package:starlight/feature/data/data_sources/upload_video/upload_video_request.dart';
import 'package:starlight/feature/data/data_sources/video_detail/video_detail_request.dart';
import 'package:starlight/feature/data/data_sources/video_detail/video_detail_service.dart';
import 'package:starlight/feature/data/data_sources/youtube/youtube_api_service.dart';
import 'package:starlight/feature/data/models/youtube_search.dart';
import 'package:starlight/feature/domain/entities/video_detail/video_detail.dart';
import 'package:starlight/feature/domain/repositories/upload_video/upload_video_repository.dart';
import 'package:starlight/feature/domain/repositories/video_detail/video_detail_repository.dart';
import 'package:starlight/feature/domain/repositories/youtube_repository.dart';

import '../../../../core/resources/data_state.dart';
import '../../../domain/entities/upload_video/upload_video.dart';
import '../../data_sources/upload_video/upload_video_service.dart';
import '../../models/upload_video/upload_video.dart';

class VideoDetailRepositoryImpl implements VideoDetailRepository{
  final VideoDetailApiService _videoDetailApiService;
  VideoDetailRepositoryImpl(this._videoDetailApiService);

  @override
  Future<DataState<VideoDetailEntity>> videoDetail({required VideoDetailRequestBody body}) async {
    // TODO: implement videoDetail
    try{
      final httpResponse = await _videoDetailApiService.videoDetail(body);
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
      return DataFailed(e);
    }
  }
}