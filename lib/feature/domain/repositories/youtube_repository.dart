import 'package:starlight/feature/domain/entities/youtube_search.dart';

import '../../../core/resources/data_state.dart';

abstract class YoutubeRepository {
  Future<DataState<YoutubeSearchEntity>> getSearch({required String word});

}
