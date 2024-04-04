// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_stories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetStories _$GetStoriesFromJson(Map<String, dynamic> json) => GetStories(
      json['error'] as bool?,
      json['message'] as String?,
      (json['listStory'] as List<dynamic>?)
          ?.map((e) => ListStory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetStoriesToJson(GetStories instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'listStory': instance.listStory,
    };
