import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:starlight/core/constants/constants.dart';
import 'package:starlight/feature/data/data_sources/video_detail/video_detail_request.dart';
import 'package:starlight/feature/data/data_sources/video_highlight/video_highlight_request.dart';
import 'package:starlight/feature/data/models/video_detail/video_detail.dart';

part 'video_highlight_service.g.dart';

@RestApi(baseUrl: getHighlightBaseURL)
abstract class VideoHighlightApiService {
  factory VideoHighlightApiService(Dio dio) = _VideoHighlightApiService;

  @POST('/get-video-highlight')
  Future<HttpResponse<VideoDetailResponse>> videoHighlight(
      @Body() VideoHighlightRequestBody body,
      );
}