part of 'detail_story_bloc.dart';

@immutable
abstract class DetailStoryState {}

class DetailStoryInitial extends DetailStoryState {}

class OnLoadingDetailStory extends DetailStoryState {}

class OnSuccessDetailStory extends DetailStoryState {
  final DetailStory data;

  OnSuccessDetailStory({required this.data});
}

class OnFailedDetailStory extends DetailStoryState {
  final String message;
  final int? statusCode;

  OnFailedDetailStory({required this.message, this.statusCode});
}
