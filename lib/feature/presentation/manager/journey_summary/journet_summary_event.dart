abstract class JourneySummaryEvent {
  const JourneySummaryEvent();
}

class GetSummaryVideo extends JourneySummaryEvent {
  final String id;

  GetSummaryVideo({
    required this.id,
  });
}