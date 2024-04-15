
import 'package:starlight/feature/domain/entities/youtube_search.dart';
import 'package:starlight/feature/domain/repositories/youtube_repository.dart';

import '../../../core/resources/data_state.dart';
import '../../../core/usecase/usecase.dart';

class GetYoutubeSearchUseCase implements UseCase<DataState<YoutubeSearchEntity>, String> {
  final YoutubeRepository _youtubeRepository;

  GetYoutubeSearchUseCase(this._youtubeRepository);

  @override
  Future<DataState<YoutubeSearchEntity>> call({String? params}) {
    return _youtubeRepository.getSearch(word: params?? "Travel Thailand" );
  }
}