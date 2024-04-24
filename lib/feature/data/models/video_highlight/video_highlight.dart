
import '../../../domain/entities/video_highlight/video_highlight.dart';

class VideoHighlightResponse extends VideoHighlightEntity{
  const VideoHighlightResponse({
    required super.content,
    required super.contentSummary
  });

  factory VideoHighlightResponse.fromJson(Map<String, dynamic> json) {
    return VideoHighlightResponse(
      content: (json['content'] as List<dynamic>?)
          ?.map((item) => Content.fromJson(item))
          .toList() ?? [],
      contentSummary: json['content_summary']
    );
  }
}

