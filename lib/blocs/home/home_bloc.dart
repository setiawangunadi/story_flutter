import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:story_app/config/data/exception/network.dart';
import 'package:story_app/config/data/exception/session_expired.dart';
import 'package:story_app/config/data/local/shared_prefs_storage.dart';
import 'package:story_app/config/models/get_stories.dart';
import 'package:story_app/config/repositories/story_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StoryRepository storyRepository = StoryRepository();

  HomeBloc() : super(HomeInitial()) {
    on<GetListStory>(getListStory);
    on<DoLogout>(doLogout);
  }

  Future<void> getListStory(
    GetListStory event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(OnLoadingHome());
      final response = await storyRepository.getListStory(
        size: event.size,
        page: event.page,
      );
      if (response.statusCode == 200) {
        var data = GetStories.fromJson(response.data);
        if (data.error == false) {
          emit(OnSuccessHome(data: data));
        }
      }
    } on Network catch (e) {
      emit(OnFailedHome(message: e.responseMessage));
    } on SessionExpired catch (e) {
      emit(OnFailedHome(message: e.message));
    } catch (e) {
      emit(OnFailedHome(message: e.toString()));
    }
  }

  Future<void> doLogout(
    DoLogout event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(OnLoadingHome());
      await SharedPrefsStorage.clearAll();
      emit(OnSuccessLogout());
    } on Network catch (e) {
      emit(OnFailedHome(message: e.responseMessage));
    } on SessionExpired catch (e) {
      emit(OnFailedHome(message: e.message));
    } catch (e) {
      emit(OnFailedHome(message: e.toString()));
    }
  }
}
