// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListStory _$ListStoryFromJson(Map<String, dynamic> json) => ListStory(
      json['id'] as String?,
      json['name'] as String?,
      json['description'] as String?,
      json['photoUrl'] as String?,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      (json['lat'] as num?)?.toDouble(),
      (json['lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ListStoryToJson(ListStory instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lat': instance.lat,
      'lon': instance.lon,
    };
