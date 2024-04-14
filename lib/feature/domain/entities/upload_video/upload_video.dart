import 'package:equatable/equatable.dart';


class QueueIdEntity extends Equatable {
  final String queueId;


  const QueueIdEntity({
    required this.queueId,
  });

  @override
  List<Object?> get props {
    return [
      queueId
    ];
  }
}
