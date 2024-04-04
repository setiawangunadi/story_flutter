import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story {
  Story(
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  );

  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double lat;
  double lon;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
