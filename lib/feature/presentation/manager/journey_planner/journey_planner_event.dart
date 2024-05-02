import '../../../data/data_sources/upload_video/upload_video_request.dart';

abstract class JourneyPlannerEvent {
  const JourneyPlannerEvent();
}

class UploadVideo extends JourneyPlannerEvent {
  String? videoUrl;
  String? videoId;
  final String userId;
  final bool isUseSubtitle;
  String? prompt;
  PromptPresetRequestBody? promptPreset;

  UploadVideo({
    this.videoUrl,
    this.videoId,
    required this.userId,
    required this.isUseSubtitle,
    this.promptPreset
  });
}

class VideoDetail extends JourneyPlannerEvent {
  final String videoId;

  VideoDetail({
    required this.videoId,
  });
}