import '../../../../core/resources/data_state.dart';
import '../../../data/data_sources/video_summary/video_summary_request.dart';
import '../../entities/video_summary/video_summary.dart';

abstract class VideoSummaryRepository {
  Future<DataState<VideoSummaryEntity>> getVideoSummary({required VideoSummaryRequestBody body});

}
