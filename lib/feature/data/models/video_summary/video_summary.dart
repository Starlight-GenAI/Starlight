import 'package:starlight/feature/domain/entities/upload_video/upload_video.dart';

import '../../../domain/entities/video_summary/video_summary.dart';
import '../../../domain/entities/youtube_search.dart';


class VideoSummaryResponse extends VideoSummaryEntity{
  const VideoSummaryResponse({
    required super.content,
    required super.canGenerateTrip,
    required super.userId
  });

  factory VideoSummaryResponse.fromJson(Map<String, dynamic> json) {
    return VideoSummaryResponse(
      canGenerateTrip: json['can_generate_trip'] ?? false, // Note the key change
      userId: json['user_id'] ?? '', // Note the key change
      content: (json['content'] as List<dynamic>?)
          ?.map((item) => Content.fromJson(item))
          .toList() ?? [],
    );
  }
}

