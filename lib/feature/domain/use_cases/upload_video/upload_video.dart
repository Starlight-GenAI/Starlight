
import 'package:starlight/feature/data/data_sources/upload_video/upload_video_request.dart';
import 'package:starlight/feature/domain/entities/upload_video/upload_video.dart';
import 'package:starlight/feature/domain/repositories/upload_video/upload_video_repository.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';

class UploadVideoUseCase implements UseCase<DataState<QueueIdEntity>, VideoRequestBody> {

  final UploadVideoRepository _uploadVideoRepository;

  UploadVideoUseCase(this._uploadVideoRepository);

  @override
  Future<DataState<QueueIdEntity>> call({VideoRequestBody? params}) {
    return _uploadVideoRepository.uploadVideo(body: params ?? VideoRequestBody(videoUrl: "https://youtu.be/IuTDuvYr7f0?si=0dBf78aaB15LGIpF", isUseSubtitle: true, userId: "2", videoId: '', prompt: '', promptPreset: PromptPresetRequestBody(day: 1, city: '', journeyType: '', interestingActivity: '')));
  }
}

