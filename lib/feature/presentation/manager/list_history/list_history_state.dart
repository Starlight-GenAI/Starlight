
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/list_history/list_history.dart';

abstract class ListHistoryState extends Equatable{
  final ListHistoryEntity? list;
  final DioException? error;

  const ListHistoryState({this.list, this.error});

  @override
  List<Object?> get props => [list, error];
}

class ListHistoryLoadingState extends ListHistoryState {
  const ListHistoryLoadingState();

}

class ListHistoryLoadedState extends ListHistoryState {
  const ListHistoryLoadedState(ListHistoryEntity list) : super(list: list);
}

class ListHistoryErrorState extends ListHistoryState {
  const ListHistoryErrorState(DioException error) : super(error: error);
}
