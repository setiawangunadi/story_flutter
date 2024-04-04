import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/config/models/story.dart';

part 'detail_story.g.dart';

@JsonSerializable()
class DetailStory {
  DetailStory(this.error, this.message, this.story);

  bool error;
  String message;
  Story? story;

  factory DetailStory.fromJson(Map<String, dynamic> json) => _$DetailStoryFromJson(json);

  Map<String, dynamic> toJson() => _$DetailStoryToJson(this);
}