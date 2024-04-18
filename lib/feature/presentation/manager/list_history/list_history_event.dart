abstract class ListHistoryEvent {
  const ListHistoryEvent();
}

class GetListHistory extends ListHistoryEvent {
  final String userId;

  GetListHistory({
    required this.userId,
  });
}