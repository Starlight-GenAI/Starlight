abstract class TripPlannerEvent {
  const TripPlannerEvent();
}

class GetTripPlanner extends TripPlannerEvent {
  final String Id;

  GetTripPlanner({
    required this.Id,
  });
}