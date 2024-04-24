class VideoDetailRequestBody {
  String videoId;

  VideoDetailRequestBody({
    required this.videoId
  });

  Map<String, dynamic> toJson() {
    return {
      'video_id': videoId,
    };
  }
}