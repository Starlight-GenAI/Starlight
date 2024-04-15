import 'package:starlight/feature/data/data_sources/upload_video/upload_video_request.dart';

import '../../../../core/resources/data_state.dart';
import '../../entities/upload_video/upload_video.dart';

abstract class UploadVideoRepository {
  Future<DataState<QueueIdEntity>> uploadVideo({required VideoRequestBody body});

}
