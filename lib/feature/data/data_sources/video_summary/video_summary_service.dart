
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:starlight/core/constants/constants.dart';
import 'package:starlight/feature/data/data_sources/video_summary/video_summary_request.dart';
import '../../models/video_summary/video_summary.dart';

part 'video_summary_service.g.dart';

@RestApi(baseUrl: starlightServiceBaseURL)
abstract class VideoSummaryService {
  factory VideoSummaryService(Dio dio) = _VideoSummaryService;

  @POST('/get-video-summary')
  Future<HttpResponse<VideoSummaryResponse>> getVideoSummary(
      @Body() VideoSummaryRequestBody body,
      );
}