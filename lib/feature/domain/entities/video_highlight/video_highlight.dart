

import 'package:equatable/equatable.dart';

class VideoHighlightEntity extends Equatable{
  final List<Content> content;

  const VideoHighlightEntity({
    required this.content,
  });

  @override
  List<Object> get props{
    return [
      content,
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
