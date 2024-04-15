import 'package:starlight/feature/data/data_sources/upload_video/upload_video_request.dart';

abstract class JourneyPlannerEvent {
  const JourneyPlannerEvent();
}

class UploadVideo extends JourneyPlannerEvent {
  // final VideoRequestBody videoRequestBody;
  //
  // UploadVideo({required this.videoRequestBody});
  final String videoUrl;
  final String userId;
  final bool isUseSubtitle;

  UploadVideo({
    required this.videoUrl,
    required this.userId,
    required this.isUseSubtitle,
  });
}