import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:starlight/core/constants/constants.dart';
import 'package:starlight/feature/data/data_sources/video_detail/video_detail_request.dart';
import 'package:starlight/feature/data/models/video_detail/video_detail.dart';

part 'video_detail_service.g.dart';

@RestApi(baseUrl: uploadVideoBaseURL)
abstract class VideoDetailApiService {
  factory VideoDetailApiService(Dio dio) = _VideoDetailApiService;

  @POST('/video-info')
  Future<HttpResponse<VideoDetailResponse>> videoDetail(
      @Body() VideoDetailRequestBody body,
      );
}