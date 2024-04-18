
import 'package:starlight/feature/domain/repositories/list_history/list_history_repository.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/data_sources/list_history/list_history_request.dart';
import '../../entities/list_history/list_history.dart';

class ListHistoryUseCase implements UseCase<DataState<ListHistoryEntity>, ListHistoryRequestBody> {

  final ListHistoryRepository _listHistoryRepository;

  ListHistoryUseCase(this._listHistoryRepository);

  @override
  Future<DataState<ListHistoryEntity>> call({required ListHistoryRequestBody params}) {
    return _listHistoryRepository.getListHistory(body: params);
  }
}

