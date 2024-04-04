part of 'add_story_bloc.dart';

@immutable
abstract class AddStoryState {}

class AddStoryInitial extends AddStoryState {}

class OnLoadingAddStory extends AddStoryState {}

class OnSuccessInitialData extends AddStoryState {
  final String? path;
  final String? desc;

  OnSuccessInitialData(this.path, this.desc);
}

class OnSuccessAddStory extends AddStoryState {
  final AddStoryResponseModel data;

  OnSuccessAddStory({required this.data});
}

class GetFileImageGallery extends AddStoryState {
  final XFile value;

  GetFileImageGallery({required this.value});
}

class GetFileImageCamera extends AddStoryState {
  final XFile value;

  GetFileImageCamera({required this.value});
}

class OnFailedAddStory extends AddStoryState {
  final String message;
  final int? statusCode;

  OnFailedAddStory({required this.message, this.statusCode});
}
