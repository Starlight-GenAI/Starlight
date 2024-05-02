class VideoRequestBody {
  String videoUrl;
  String videoId;
  bool isUseSubtitle;
  String userId;
  String prompt;
  PromptPresetRequestBody promptPreset;

  VideoRequestBody({
    required this.videoUrl,
    required this.videoId,
    required this.isUseSubtitle,
    required this.userId,
    required this.prompt,
    required this.promptPreset,
  });

  Map<String, dynamic> toJson() {
    return {
      'video_url': videoUrl,
      'video_id': videoId,
      'is_use_subtitle': isUseSubtitle,
      'user_id': userId,
      'prompt': prompt,
      'prompt_preset': promptPreset.toJson(),
    };
  }
}

class PromptPresetRequestBody {
  int day;
  String city;
  String journeyType;
  String interestingActivity;

  PromptPresetRequestBody({
    required this.day,
    required this.city,
    required this.journeyType,
    required this.interestingActivity,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'city': city,
      'journey_type': journeyType,
      'interesting_activity': interestingActivity,
    };
  }
}