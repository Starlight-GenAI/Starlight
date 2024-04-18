
import 'package:dio/dio.dart';
import 'package:starlight/feature/data/data_sources/list_history/list_history_service.dart';
import 'package:starlight/feature/data/models/video_detail/video_detail.dart';

import '../../../../core/resources/data_state.dart';
import '../../../domain/entities/list_history/list_history.dart';
import '../../../domain/repositories/list_history/list_history_repository.dart';
import '../../data_sources/list_history/list_history_request.dart';
import 'dart:io';

class ListHistoryRepositoryImpl implements ListHistoryRepository {
  final ListHistoryApiService _listHistoryApiService;
  ListHistoryRepositoryImpl(this._listHistoryApiService);

  @override
  Future<DataState<ListHistoryEntity>> getListHistory({required ListHistoryRequestBody body}) async {
    try{
      final httpResponse = await _listHistoryApiService.listHistory(body);
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