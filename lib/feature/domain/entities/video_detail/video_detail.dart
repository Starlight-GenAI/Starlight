import 'package:equatable/equatable.dart';


class VideoDetailEntity extends Equatable {
  final String title;
  final String decription;
  final String thumbnails;
  final String publishAt;
  final String duration;
  final int viewCount;
  final int likeCount;


  const VideoDetailEntity({
    required this.title,
    required this.decription,
    required this.thumbnails,
    required this.publishAt,
    required this.duration,
    required this.viewCount,
    required this.likeCount,
  });

  @override
  List<Object?> get props {
    return [
      title,
      decription,
      thumbnails,
      publishAt,
      duration,
      viewCount,
      likeCount
    ];
  }
}
