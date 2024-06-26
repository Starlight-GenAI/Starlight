import 'dart:io';

import 'package:dio/dio.dart';
import 'package:starlight/core/constants/constants.dart';
import 'package:starlight/feature/data/data_sources/youtube/youtube_api_service.dart';
import 'package:starlight/feature/data/models/youtube/youtube_search.dart';
import 'package:starlight/feature/domain/repositories/youtube/youtube_repository.dart';

import '../../../../core/resources/data_state.dart';
import '../../../domain/entities/youtube/youtube_search.dart';

class YoutubeRepositoryImpl implements YoutubeRepository {
  final YoutubeApiService _youtubeApiService;
  YoutubeRepositoryImpl(this._youtubeApiService);

  @override
  Future<DataState<YoutubeSearchModel>> getSearch({required String word}) async {
    try{
      final httpResponse = await _youtubeApiService.getSearch(
          part: "snippet", maxResults: "10", q: word ,type: "video",key: youtubeAPIKey);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        print("1");
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