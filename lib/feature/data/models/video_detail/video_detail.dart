import 'dart:ffi';

import 'package:starlight/feature/domain/entities/upload_video/upload_video.dart';
import 'package:starlight/feature/domain/entities/video_detail/video_detail.dart';

class VideoDetailResponse extends VideoDetailEntity{

  const VideoDetailResponse({
    required String title,
    required String decription,
    required String thumbnails,
    required String publishAt,
    required String duration,
    required int viewCount,
    required int likeCount,
  }):super(
      title: title,
      decription: decription,
      thumbnails: thumbnails,
      publishAt: publishAt,
      duration: duration,
      viewCount: viewCount,
      likeCount: likeCount
  );

  factory VideoDetailResponse.fromJson(Map<String, dynamic> json) {
    return VideoDetailResponse(
      title: json['title'],
      decription: json['decription'],
      thumbnails: json['thumbnails'],
      publishAt: json['publish_at'],
      duration: json['duration'],
      viewCount: json['view_count'],
      likeCount: json['like_count']
    );
  }
}