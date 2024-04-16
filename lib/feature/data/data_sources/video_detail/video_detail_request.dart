class VideoDetailRequestBody {
  String videoUrl;

  VideoDetailRequestBody({
    required this.videoUrl
  });

  Map<String, dynamic> toJson() {
    return {
      'video_url': videoUrl,
    };
  }
}