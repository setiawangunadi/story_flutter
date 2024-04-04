import 'package:json_annotation/json_annotation.dart';

part 'list_story.g.dart';

@JsonSerializable()
class ListStory {
  ListStory(
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  );

  String? id;
  String? name;
  String? description;
  String? photoUrl;
  DateTime? createdAt;
  double? lat;
  double? lon;

  factory ListStory.fromJson(Map<String, dynamic> json) =>
      _$ListStoryFromJson(json);

  Map<String, dynamic> toJson() => _$ListStoryToJson(this);
}
