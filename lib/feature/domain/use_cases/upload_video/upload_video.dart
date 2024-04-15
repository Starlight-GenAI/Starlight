
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
    print('////////params////////');
    print(params);
    return _uploadVideoRepository.uploadVideo(body: params ?? VideoRequestBody(videoUrl: "videoUrl", isUseSubtitle: true, userId: "userId"));
  }
}

