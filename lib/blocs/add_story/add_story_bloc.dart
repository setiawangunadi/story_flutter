import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/config/data/exception/network.dart';
import 'package:story_app/config/data/exception/session_expired.dart';
import 'package:story_app/config/models/add_story.dart';
import 'package:story_app/config/repositories/story_repository.dart';

part 'add_story_event.dart';
part 'add_story_state.dart';

class AddStoryBloc extends Bloc<AddStoryEvent, AddStoryState> {
  final StoryRepository storyRepository = StoryRepository();

  AddStoryBloc() : super(AddStoryInitial()) {
    on<DoInitialData>(doInitialData);
    on<DoAddStory>(doAddStory);
    on<SetImageFileCamera>(setImageFileCamera);
    on<SetImageFileGallery>(setImageFileGallery);
  }

  Future<void> doInitialData(
      DoInitialData event,
      Emitter<AddStoryState> emit,
      ) async {
    try {
      emit(OnLoadingAddStory());
      emit(OnSuccessInitialData(event.path, event.desc));
    } on Network catch (e) {
      emit(OnFailedAddStory(message: e.responseMessage));
    } on SessionExpired catch (e) {
      emit(OnFailedAddStory(message: e.message));
    } catch (e) {
      emit(OnFailedAddStory(message: e.toString()));
    }
  }

  Future<void> doAddStory(
    DoAddStory event,
    Emitter<AddStoryState> emit,
  ) async {
    try {
      emit(OnLoadingAddStory());
      final response = await storyRepository.doAddStory(
        description: event.description,
        imagePath: event.filePath,
        imageName: event.filename,
        longitude: event.lon,
        latitude: event.lat
      );
      var data =
          AddStory.fromJson(response.data);
      if (data.error == false) {
        emit(OnSuccessAddStory(data: data));
      }

      if (data.error == true) {
        emit(OnFailedAddStory(message: data.message));
      }
    } on Network catch (e) {
      emit(OnFailedAddStory(message: e.responseMessage));
    } on SessionExpired catch (e) {
      emit(OnFailedAddStory(message: e.message));
    } catch (e) {
      emit(OnFailedAddStory(message: e.toString()));
    }
  }

  Future<void> setImageFileCamera(
    SetImageFileCamera event,
    Emitter<AddStoryState> emit,
  ) async {
    try {
      emit(OnLoadingAddStory());
      emit(GetFileImageCamera(value: event.value));
    } on Network catch (e) {
      emit(OnFailedAddStory(message: e.responseMessage));
    } on SessionExpired catch (e) {
      emit(OnFailedAddStory(message: e.message));
    }catch (e) {
      emit(OnFailedAddStory(message: e.toString()));
    }
  }

  Future<void> setImageFileGallery(
    SetImageFileGallery event,
    Emitter<AddStoryState> emit,
  ) async {
    try {
      emit(OnLoadingAddStory());
      emit(GetFileImageCamera(value: event.value));
    } on Network catch (e) {
      emit(OnFailedAddStory(message: e.responseMessage));
    } on SessionExpired catch (e) {
      emit(OnFailedAddStory(message: e.message));
    }catch (e) {
      emit(OnFailedAddStory(message: e.toString()));
    }
  }
}
