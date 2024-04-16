class VideoSummaryRequestBody {
  String id;

  VideoSummaryRequestBody({
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}