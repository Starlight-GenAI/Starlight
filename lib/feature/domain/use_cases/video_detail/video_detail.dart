
import 'package:starlight/feature/data/data_sources/video_detail/video_detail_request.dart';
import 'package:starlight/feature/domain/entities/video_detail/video_detail.dart';
import 'package:starlight/feature/domain/repositories/video_detail/video_detail_repository.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';

class VideoDetailUseCase implements UseCase<DataState<VideoDetailEntity>, VideoDetailRequestBody> {

  final VideoDetailRepository _videoDetailRepository;

  VideoDetailUseCase(this._videoDetailRepository);

  @override
  Future<DataState<VideoDetailEntity>> call({VideoDetailRequestBody? params}) {
    return _videoDetailRepository.videoDetail(body: params ?? VideoDetailRequestBody(videoId: "https://youtu.be/IuTDuvYr7f0?si=0dBf78aaB15LGIpF"));
  }
}

