
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight/feature/domain/use_cases/list_history/list_history.dart';

import '../../../../core/resources/data_state.dart';
import '../../../data/data_sources/list_history/list_history_request.dart';
import 'list_history_event.dart';
import 'list_history_state.dart';

class ListHistoryBloc extends Bloc<ListHistoryEvent, ListHistoryState> {
  final ListHistoryUseCase _getListHistoryUseCase;

  ListHistoryBloc( this._getListHistoryUseCase) : super(const ListHistoryLoadingState()) {
    on<GetListHistory>(_onGetListHistory);
  }

  void _onGetListHistory(GetListHistory event, Emitter<ListHistoryState> emit) async {
    emit(const ListHistoryLoadingState());

    try {
      emit(const ListHistoryLoadingState());
      final dataState = await _getListHistoryUseCase(params: ListHistoryRequestBody( user_id: event.userId));
      if (dataState is DataSuccess) {
        print('success');
        print(dataState.data?.items[0].title);

        print(dataState.data?.items[0].status);
        emit(ListHistoryLoadedState(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(ListHistoryErrorState(dataState.error!));
      }
    } catch (e) {
      print('fail 2');

      emit(ListHistoryErrorState(DioException(error: e.toString(), requestOptions: RequestOptions())));
    }
  }

}
