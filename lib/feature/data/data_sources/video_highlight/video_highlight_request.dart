class VideoHighlightRequestBody {
  String id;

  VideoHighlightRequestBody({
    required this.id
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}