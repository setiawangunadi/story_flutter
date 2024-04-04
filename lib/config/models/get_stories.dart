import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/config/models/list_story.dart';

part 'get_stories.g.dart';

@JsonSerializable()
class GetStories {
  GetStories(this.error, this.message, this.listStory);
  
  bool? error;
  String? message;
  List<ListStory>? listStory;

  factory GetStories.fromJson(Map<String, dynamic> json) => _$GetStoriesFromJson(json);

  Map<String, dynamic> toJson() => _$GetStoriesToJson(this);
}