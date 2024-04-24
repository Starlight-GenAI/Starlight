abstract class JourneyPlannerEvent {
  const JourneyPlannerEvent();
}

class UploadVideo extends JourneyPlannerEvent {
  String? videoUrl;
  String? videoId;
  final String userId;
  final bool isUseSubtitle;

  UploadVideo({
    this.videoUrl,
    this.videoId,
    required this.userId,
    required this.isUseSubtitle,
  });
}

class VideoDetail extends JourneyPlannerEvent {
  final String videoId;

  VideoDetail({
    required this.videoId,
  });
}