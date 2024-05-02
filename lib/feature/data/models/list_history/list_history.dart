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
  final String createdAt;
  final String updateAt;
  final String channelName;
  final bool isUseSubtitle;
  final String prompt;
  final Object promptPreset;

  const ListHistoryItemResponse({
    required this.queueId,
    required this.videoUrl,
    required this.videoId,
    required this.status,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.createdAt,
    required this.updateAt,
    required this.channelName,
    required this.isUseSubtitle,
    required this.prompt,
    required this.promptPreset
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
      createdAt: json['created_at'],
      updateAt: json['updated_at'],
      channelName: json['channel_name'],
      isUseSubtitle: json['is_use_subtitle'],
      prompt: json['prompt'],
      promptPreset: json['prompt_preset'],

    );
  }
}
