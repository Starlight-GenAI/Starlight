
import '../../../domain/entities/trip_planner/trip_planner.dart';

class TripPlannerResponse extends TripPlannerEntity{
  TripPlannerResponse({
    required super.content,
    required super.userId
  });

  factory TripPlannerResponse.fromJson(Map<String, dynamic> json) {
    return TripPlannerResponse(
      content: (json['content'] as List<dynamic>?)
          ?.map((item) => Content.fromJson(item))
          .toList() ?? [],
      userId: json['user_id']
    );
  }
}

