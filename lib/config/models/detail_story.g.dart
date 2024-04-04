// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailStory _$DetailStoryFromJson(Map<String, dynamic> json) => DetailStory(
      json['error'] as bool,
      json['message'] as String,
      json['story'] == null
          ? null
          : Story.fromJson(json['story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailStoryToJson(DetailStory instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'story': instance.story,
    };
