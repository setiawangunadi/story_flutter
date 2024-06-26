import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:story_app/config/data/exception/network.dart';
import 'package:story_app/config/data/exception/session_expired.dart';
import 'package:story_app/config/models/detail_story.dart';
import 'package:story_app/config/repositories/story_repository.dart';

part 'detail_story_event.dart';

part 'detail_story_state.dart';

class DetailStoryBloc extends Bloc<DetailStoryEvent, DetailStoryState> {
  final StoryRepository storyRepository = StoryRepository();

  DetailStoryBloc() : super(DetailStoryInitial()) {
    on<GetDetailStory>(getDetailStory);
  }

  Future<void> getDetailStory(
    GetDetailStory event,
    Emitter<DetailStoryState> emit,
  ) async {
    try {
      emit(OnLoadingDetailStory());
      final response = await storyRepository.getDetailStory(id: event.id);
      debugPrint("THIS DATA RESPONSE : ${response.data}");
      if (response.statusCode == 200) {
        var data = DetailStory.fromJson(response.data);
        debugPrint("THIS DATA RESPONSE : ${data.story?.toJson()}");
        if (data.error == false) {
          emit(OnSuccessDetailStory(data: data));
        }
      }
    } on Network catch (e) {
      emit(OnFailedDetailStory(message: e.responseMessage));
    } on SessionExpired catch (e) {
      emit(OnFailedDetailStory(message: e.message));
    } catch (e) {
      emit(OnFailedDetailStory(message: e.toString()));
    }
  }
}
