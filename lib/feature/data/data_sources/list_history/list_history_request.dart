class ListHistoryRequestBody {
  String user_id;

  ListHistoryRequestBody({
    required this.user_id
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
    };
  }
}