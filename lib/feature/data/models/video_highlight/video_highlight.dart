import 'package:starlight/feature/domain/entities/upload_video/upload_video.dart';

import '../../../domain/entities/video_summary/video_summary.dart';
import '../../../domain/entities/youtube/youtube_search.dart';


class VideoHighlightResponse extends VideoSummaryEntity{
  const VideoHighlightResponse({
    required super.content,
    required super.canGenerateTrip,
    required super.userId
  });

  factory VideoHighlightResponse.fromJson(Map<String, dynamic> json) {
    return VideoHighlightResponse(
      canGenerateTrip: json['can_generate_trip'] ?? false, // Note the key change
      userId: json['user_id'] ?? '', // Note the key change
      content: (json['content'] as List<dynamic>?)
          ?.map((item) => Content.fromJson(item))
          .toList() ?? [],
    );
  }
}

