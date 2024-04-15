abstract class JourneyPlannerEvent {
  const JourneyPlannerEvent();
}

class UploadVideo extends JourneyPlannerEvent {
  final String videoUrl;
  final String userId;
  final bool isUseSubtitle;

  UploadVideo({
    required this.videoUrl,
    required this.userId,
    required this.isUseSubtitle,
  });
}