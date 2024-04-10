
import 'package:starlight/feature/domain/entities/youtube_search.dart';

class YoutubeSearchModel extends YoutubeSearchEntity {
  const YoutubeSearchModel({
     String? kind,
     String? etag,
     String? nextPageToken,
     String? regionCode,
     PageInfo? pageInfo,
     List<Item>? items}): super(
    kind: kind,
    etag: etag,
    nextPageToken: nextPageToken,
    regionCode: regionCode,
    pageInfo: pageInfo,
    items: items
  );

  factory YoutubeSearchModel.fromJson(Map < String, dynamic > map) {
    return YoutubeSearchModel(
      kind: map['kind'],
      etag: map['etag'],
      nextPageToken: map['nextPageToken'],
      regionCode: map['regionCode'],
      pageInfo: PageInfo.fromJson(map['pageInfo']),
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => Item.fromJson(item))
          .toList(),
    );
  }
}
