
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:starlight/core/constants/constants.dart';
import 'package:starlight/feature/data/data_sources/upload_video/upload_video_request.dart';
import 'package:starlight/feature/data/models/upload_video/upload_video.dart';
import '../../models/youtube_search.dart';

part 'youtube_api_service.g.dart';

@RestApi(baseUrl: youtubeAPIBaseURL)
abstract class UploadVideoApiService {
  factory UploadVideoApiService(Dio dio) = _UploadVideoApiService;

  @POST('/your_endpoint') // Change annotation to POST and specify your endpoint
  Future<HttpResponse<QueueIdResponse>> uploadVideo(
      @Body() VideoRequestBody body,
      );
}