import 'package:starlight/feature/data/data_sources/list_history/list_history_request.dart';

import '../../../../core/resources/data_state.dart';
import '../../entities/list_history/list_history.dart';

abstract class ListHistoryRepository {
  Future<DataState<ListHistoryEntity>> getListHistory({required ListHistoryRequestBody body});

}
