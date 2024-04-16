
import 'package:starlight/feature/domain/entities/video_summary/video_summary.dart';
import 'package:starlight/feature/domain/repositories/video_summary/video_summary_repository.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/data_sources/video_summary/video_summary_request.dart';

class GetYoutubeVideoInfoUseCase implements UseCase<DataState<VideoSummaryEntity>, VideoSummaryRequestBody> {
  final VideoSummaryRepository _videoSummaryRepository;

  GetYoutubeVideoInfoUseCase(this._videoSummaryRepository);

  @override
  Future<DataState<VideoSummaryEntity>> call({VideoSummaryRequestBody? params}) {
    return _videoSummaryRepository.getVideoSummary(body: params?? VideoSummaryRequestBody(id: ""));
  }
}