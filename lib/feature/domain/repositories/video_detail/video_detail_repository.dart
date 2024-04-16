import 'package:starlight/feature/data/data_sources/video_detail/video_detail_request.dart';
import 'package:starlight/feature/domain/entities/video_detail/video_detail.dart';
import '../../../../core/resources/data_state.dart';

abstract class VideoDetailRepository {
  Future<DataState<VideoDetailEntity>> videoDetail({required VideoDetailRequestBody body});

}
