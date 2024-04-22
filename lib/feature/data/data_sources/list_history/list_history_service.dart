import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:starlight/core/constants/constants.dart';
import 'package:starlight/feature/data/models/list_history/list_history.dart';
import 'package:starlight/feature/data/models/video_detail/video_detail.dart';

import 'list_history_request.dart';

part 'list_history_service.g.dart';

@RestApi(baseUrl: starlightServiceBaseURL)
abstract class ListHistoryApiService {
  factory ListHistoryApiService(Dio dio) = _ListHistoryApiService;

  @POST('/list-queue-history')
  Future<HttpResponse<ListHistoryResponse>> listHistory(
      @Body() ListHistoryRequestBody body,
      );
}