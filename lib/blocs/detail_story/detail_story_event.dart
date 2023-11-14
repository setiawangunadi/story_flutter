part of 'detail_story_bloc.dart';

@immutable
abstract class DetailStoryEvent {}

class GetDetailStory extends DetailStoryEvent {
  final String id;

  GetDetailStory({required this.id});
}