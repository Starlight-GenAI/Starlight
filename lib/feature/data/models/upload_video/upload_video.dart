class QueueIdResponse {
  String queueId;

  QueueIdResponse({
    required this.queueId,
  });

  factory QueueIdResponse.fromJson(Map<String, dynamic> json) {
    return QueueIdResponse(
      queueId: json['queue_id'],
    );
  }
}