import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:story_app/config/models/detail_story_response_model.dart';
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
      if (response.statusCode == 200) {
        DetailStoryResponseModel data =
        DetailStoryResponseModel.fromJson(response.data);
        if (data.error == false) {
          emit(OnSuccessDetailStory(data: data));
        }
      }
    } catch (e) {
      emit(OnFailedDetailStory(message: e.toString()));
    }
  }
}
