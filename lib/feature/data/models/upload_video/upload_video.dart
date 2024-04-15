import 'package:starlight/feature/domain/entities/upload_video/upload_video.dart';

class QueueIdResponse extends QueueIdEntity{

  const QueueIdResponse({
    required String queueId,
  }):super(queueId: queueId);

  factory QueueIdResponse.fromJson(Map<String, dynamic> json) {
    return QueueIdResponse(
      queueId: json['queue_id'],
    );
  }
}