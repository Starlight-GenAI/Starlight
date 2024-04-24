class VideoRequestBody {
  String videoUrl;
  String videoId;
  bool isUseSubtitle;
  String userId;

  VideoRequestBody({
    required this.videoUrl,
    required this.videoId,
    required this.isUseSubtitle,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'video_url': videoUrl,
      'video_id': videoId,
      'is_use_subtitle': isUseSubtitle,
      'user_id': userId,
    };
  }
}