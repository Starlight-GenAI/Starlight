import '../../../../core/resources/data_state.dart';
import '../../../data/data_sources/video_highlight/video_highlight_request.dart';
import '../../entities/video_highlight/video_highlight.dart';

abstract class VideoHighlightRepository {
  Future<DataState<VideoHighlightEntity>> getVideoHighlight({required VideoHighlightRequestBody body});

}
