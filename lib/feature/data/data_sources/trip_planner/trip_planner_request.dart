class TripPlannerRequestBody {
  String id;

  TripPlannerRequestBody({
    required this.id
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}