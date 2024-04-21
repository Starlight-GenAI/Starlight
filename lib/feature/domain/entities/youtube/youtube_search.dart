import 'package:equatable/equatable.dart';

class YoutubeSearchEntity extends Equatable {
  final String? kind;
  final String? etag;
  final String? nextPageToken;
  final String? regionCode;
  final PageInfo? pageInfo;
  final List<Item>? items;

  const YoutubeSearchEntity({
    this.kind,
    this.etag,
    this.nextPageToken,
    this.regionCode,
    this.pageInfo,
    this.items,
  });

  @override
  List<Object?> get props {
    return [
      kind,
      etag,
      nextPageToken,
      regionCode,
      pageInfo,
      items,
    ];
  }
}

class PageInfo {
  final int? totalResults;
  final int? resultsPerPage;

  PageInfo({
    this.totalResults,
    this.resultsPerPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      totalResults: json['totalResults'],
      resultsPerPage: json['resultsPerPage'],
    );
  }
}

class Item {
  final ItemKind? kind;
  final String? etag;
  final Id? id;
  final Snippet? snippet;

  Item({
    this.kind,
    this.etag,
    this.id,
    this.snippet,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      etag: json['etag'],
      id: Id.fromJson(json['id']),
      snippet: Snippet.fromJson(json['snippet']),
    );
  }
}

class Id {
  final IdKind? kind;
  final String? videoId;

  Id({
    this.kind,
    this.videoId,
  });

  factory Id.fromJson(Map<String, dynamic> json) {
    return Id(
      videoId: json['videoId'],
    );
  }
}

class Snippet {
  final String? publishedAt;
  final String? channelId;
  final String? title;
  final String? description;
  final Thumbnails? thumbnails;
  final String? channelTitle;
  final String? liveBroadcastContent;
  final String? publishTime;

  Snippet({
    this.publishedAt,
    this.channelId,
    this.title,
    this.description,
    this.thumbnails,
    this.channelTitle,
    this.liveBroadcastContent,
    this.publishTime,
  });

  factory Snippet.fromJson(Map<String, dynamic> json) {
    return Snippet(
      publishedAt: json['publishedAt'],
      channelId: json['channelId'],
      title: json['title'],
      description: json['description'],
      thumbnails: Thumbnails.fromJson(json['thumbnails']),
      channelTitle: json['channelTitle'],
      liveBroadcastContent: json['liveBroadcastContent'],
      publishTime: json['publishTime'],
    );
  }
}

class Thumbnails {
  final Default? thumbnailsDefault;
  final Default? medium;
  final Default? high;

  Thumbnails({
    this.thumbnailsDefault,
    this.medium,
    this.high,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) {
    return Thumbnails(
      thumbnailsDefault: Default.fromJson(json['default']),
      medium: Default.fromJson(json['medium']),
      high: Default.fromJson(json['high']),
    );
  }
}

class Default {
  final String? url;
  final int? width;
  final int? height;

  Default({
    this.url,
    this.width,
    this.height,
  });

  factory Default.fromJson(Map<String, dynamic> json) {
    return Default(
      url: json['url'],
      width: json['width'],
      height: json['height'],
    );
  }
}

enum IdKind {
  YOUTUBE_VIDEO
}

enum ItemKind {
  YOUTUBE_SEARCH_RESULT
}

enum LiveBroadcastContent {
  NONE
}
