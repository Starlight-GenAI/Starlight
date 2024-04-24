

import 'package:equatable/equatable.dart';

class VideoHighlightEntity extends Equatable{
  final List<Content> content;
  final String contentSummary;

  const VideoHighlightEntity({
    required this.content,
    required this.contentSummary
  });

  @override
  List<Object> get props{
    return [
      content,
      contentSummary
    ];
  }
}
class Content {
  final String? highlightName;
  final String? highlightDetail;

  Content({
    this.highlightName,
    this.highlightDetail,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
        highlightName: json['hightlight_name'],
      highlightDetail: json['highlight_detail'],
    );
  }
}
