import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/resources/data_state.dart';
import '../../../domain/entities/trip_planner/trip_planner.dart';
import '../../../domain/repositories/trip_planner/trip_planner_repository.dart';
import '../../data_sources/trip_planner/trip_planner_request.dart';
import '../../data_sources/trip_planner/trip_planner_service.dart';


class TripPlannerRepositoryImpl implements TripPlannerRepository {
  final TripPlannerApiService _tripPlannerApiService;
  TripPlannerRepositoryImpl(this._tripPlannerApiService);

  @override
  Future<DataState<TripPlannerEntity>> getPlan({required TripPlannerRequestBody body}) async {
    try{
      final httpResponse = await _tripPlannerApiService.getPlan(body);
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