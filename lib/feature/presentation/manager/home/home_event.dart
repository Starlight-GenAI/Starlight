abstract class HomeEvent {
  const HomeEvent();
}

class YoutubeSearch extends HomeEvent {
  final String word;

  YoutubeSearch({required this.word});
}