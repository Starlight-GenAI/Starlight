import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:starlight/core/constants/constants.dart';
import 'package:starlight/feature/data/data_sources/trip_planner/trip_planner_request.dart';
import 'package:starlight/feature/data/data_sources/video_detail/video_detail_request.dart';
import 'package:starlight/feature/data/data_sources/video_highlight/video_highlight_request.dart';
import 'package:starlight/feature/data/models/trip_planner/trip_planner.dart';
import 'package:starlight/feature/data/models/video_detail/video_detail.dart';
import 'package:starlight/feature/data/models/video_highlight/video_highlight.dart';

part 'trip_planner_service.g.dart';

@RestApi(baseUrl: starlightServiceBaseURL)
abstract class TripPlannerApiService {
  factory TripPlannerApiService(Dio dio) = _TripPlannerApiService;

  @POST('/get-trip-summary')
  Future<HttpResponse<TripPlannerResponse>> getPlan(
      @Body() TripPlannerRequestBody body,
      );
}