

import 'package:starlight/feature/data/data_sources/video_highlight/video_highlight_request.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../../entities/video_highlight/video_highlight.dart';
import '../../repositories/video_highlight/video_highlight_repository.dart';

class VideoHighlightUseCase implements UseCase<DataState<VideoHighlightEntity>, VideoHighlightRequestBody> {
  final VideoHighlightRepository _videoHighlightRepository;

  VideoHighlightUseCase(this._videoHighlightRepository);

  @override
  Future<DataState<VideoHighlightEntity>> call({VideoHighlightRequestBody? params}) {
    return _videoHighlightRepository.getVideoHighlight(body: params?? VideoHighlightRequestBody(id: ""));
  }
}