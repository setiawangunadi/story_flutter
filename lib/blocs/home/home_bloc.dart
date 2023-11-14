import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:story_app/config/models/get_stories_response_model.dart';
import 'package:story_app/config/repositories/story_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StoryRepository storyRepository = StoryRepository();

  HomeBloc() : super(HomeInitial()) {
    on<GetListStory>(getListStory);
  }

  Future<void> getListStory(
    GetListStory event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(OnLoadingHome());
      final response = await storyRepository.getListStory();
      if (response.statusCode == 200) {
        GetStoriesResponseModel data =
            GetStoriesResponseModel.fromJson(response.data);
        if (data.error == false) {
          emit(OnSuccessHome(data: data));
        }
      }
    } catch (e) {
      emit(OnFailedHome(message: e.toString()));
    }
  }
}
