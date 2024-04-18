import 'package:equatable/equatable.dart';

import '../../../data/models/list_history/list_history.dart';
class ListHistoryEntity extends Equatable {
  final List<ListHistoryItemResponse> items;

  const ListHistoryEntity({
    required this.items,
  });

  @override
  List<Object?> get props => [items];
}
