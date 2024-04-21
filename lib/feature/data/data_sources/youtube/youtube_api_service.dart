
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:starlight/core/constants/constants.dart';
import '../../models/youtube/youtube_search.dart';

part 'youtube_api_service.g.dart';

@RestApi(baseUrl: youtubeAPIBaseURL)
abstract class YoutubeApiService {
  factory YoutubeApiService(Dio dio) = _YoutubeApiService;

  @GET('/search')
  Future<HttpResponse<YoutubeSearchModel>> getSearch({
    @Query("part") String ? part,
    @Query("maxResults") String ? maxResults,
    @Query("q") String ? q,
    @Query("type") String ? type,
    @Query("key") String ? key,
  });
}