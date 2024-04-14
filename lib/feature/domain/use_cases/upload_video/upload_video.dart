
import 'package:starlight/feature/domain/entities/upload_video/upload_video.dart';
import 'package:starlight/feature/domain/entities/youtube_search.dart';
import 'package:starlight/feature/domain/repositories/upload_video/upload_video_repository.dart';
import 'package:starlight/feature/domain/repositories/youtube_repository.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';

class UploadVideoUsecase implements UseCase<DataState<QueueIdEntity>, void>{

  final UploadVideoRepository _uploadVideoRepository;
  UploadVideoUsecase(this._uploadVideoRepository);

  @override
  Future<DataState<QueueIdEntity>> call({void params}) {
    return _uploadVideoRepository.uploadVideo();
  }

}