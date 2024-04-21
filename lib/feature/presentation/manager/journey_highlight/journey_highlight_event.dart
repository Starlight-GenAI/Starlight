abstract class JourneyHighlightEvent {
  const JourneyHighlightEvent();
}

class GetHighlight extends JourneyHighlightEvent {
  final String Id;

  GetHighlight({
    required this.Id,
  });
}