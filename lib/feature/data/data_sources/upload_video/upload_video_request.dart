class VideoRequestBody {
  String videoUrl;
  bool isUseSubtitle;
  String userId;

  VideoRequestBody({
    required this.videoUrl,
    required this.isUseSubtitle,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'video_url': videoUrl,
      'is_use_subtitle': isUseSubtitle,
      'user_id': userId,
    };
  }
}