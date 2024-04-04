import 'package:json_annotation/json_annotation.dart';

part 'add_story.g.dart';

@JsonSerializable()
class AddStory {
  AddStory(this.error, this.message);

  bool error;
  String message;

  factory AddStory.fromJson(Map<String, dynamic> json) => _$AddStoryFromJson(json);

  Map<String, dynamic> toJson() => _$AddStoryToJson(this);
}