import 'package:equatable/equatable.dart';

class TripPlannerEntity extends Equatable {
  final List<Content>? content;
  final String? userId;

  TripPlannerEntity({
    this.content,
    this.userId,
  });

  @override
  List<Object?> get props => [content, userId];
}

class Content {
  final String? day;
  final List<LocationWithSummary>? locationWithSummary;
  final int? countDining;

  Content({
    this.day,
    this.locationWithSummary,
    this.countDining
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      day: json['day'],
      locationWithSummary: (json['location_with_summary'] as List<dynamic>?)
          ?.map((item) => LocationWithSummary.fromJson(item))
          .toList() ?? [],
      countDining: json['count_dining']
    );
  }
}

class LocationWithSummary {
  final String? locationName;
  final String? summary;
  final String? placeId;
  final double? lat;
  final double? lng;
  final double? rating;
  final String? category;
  final List<String>? photos;
  final bool? hasRecommendedRestaurant;
  final RecommendedRestaurant? recommendedRestaurant;

  LocationWithSummary({
    this.locationName,
    this.summary,
    this.placeId,
    this.lat,
    this.lng,
    this.rating,
    this.category,
    this.photos,
    this.hasRecommendedRestaurant,
    this.recommendedRestaurant,
  });

  factory LocationWithSummary.fromJson(Map<String, dynamic> json) {
    return LocationWithSummary(
      locationName: json['location_name'],
      summary: json['summary'],
      placeId: json['place_id'],
      lat: json['lat']?.toDouble(), // Convert to double
      lng: json['lng']?.toDouble(), // Convert to double
      rating: json['rating']?.toDouble(), // Convert to double
      category: json['category'],
      photos: json['photos'] != null
          ? List<String>.from(json['photos']) // Convert to List<String>
          : [],
      hasRecommendedRestaurant: json['has_recommended_restaurant'],
      recommendedRestaurant: json['recommended_restaurant'] != null
          ? RecommendedRestaurant.fromJson(json['recommended_restaurant'])
          : null,
    );
  }
}

class RecommendedRestaurant {
  final String? name;
  final String? summary;
  final double? rating;
  final double? lat;
  final double? lng;
  final List<String>? photos;

  RecommendedRestaurant({
    this.name,
    this.summary,
    this.rating,
    this.lat,
    this.lng,
    this.photos,
  });

  factory RecommendedRestaurant.fromJson(Map<String, dynamic> json) {
    return RecommendedRestaurant(
      name: json['name'],
      summary: json['summary'],
      rating: json['rating']?.toDouble(), // Convert to double
      lat: json['lat']?.toDouble(), // Convert to double
      lng: json['lng']?.toDouble(), // Convert to double
      photos: json['photos'] != null
          ? List<String>.from(json['photos']) // Convert to List<String>
          : [],
    );
  }
}
