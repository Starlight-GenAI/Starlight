import '../../../domain/entities/list_history/list_history.dart';

class ListHistoryResponse extends ListHistoryEntity {
  const ListHistoryResponse({
    required List<ListHistoryItemResponse> items,
  }) : super(items: items);

  factory ListHistoryResponse.fromJson(List<dynamic> json) {
    final items =
        json.map((item) => ListHistoryItemResponse.fromJson(item)).toList();
    return ListHistoryResponse(items: items);
  }
}

class ListHistoryItemResponse {
  final String queueId;
  final String videoUrl;
  final String videoId;
  final String status;
  final String title;
  final String description;
  final String thumbnails;

  const ListHistoryItemResponse({
    required this.queueId,
    required this.videoUrl,
    required this.videoId,
    required this.status,
    required this.title,
    required this.description,
    required this.thumbnails,
  });

  factory ListHistoryItemResponse.fromJson(Map<String, dynamic> json) {
    return ListHistoryItemResponse(
      queueId: json['queue_id'],
      videoUrl: json['video_url'],
      videoId: json['video_id'],
      status: json['status'],
      title: json['title'],
      description: json['description'],
      thumbnails: json['thumbnails'],
    );
  }
}
