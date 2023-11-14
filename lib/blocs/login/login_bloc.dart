import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:story_app/config/data/local/shared_prefs_storage.dart';
import 'package:story_app/config/models/login_response_model.dart';
import 'package:story_app/config/repositories/login_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository = LoginRepository();

  LoginBloc() : super(LoginInitial()) {
    on<DoLogin>(doLogin);
    on<DoCheckLoggedIn>(doCheckLoggedIn);
  }

  Future<void> doLogin(
    DoLogin event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(OnLoadingLogin());
      final response = await loginRepository.doLogin(
          email: event.email, password: event.password);
      if (response.statusCode == 200) {
        LoginResponseModel data = LoginResponseModel.fromJson(response.data);
        SharedPrefsStorage.setTokenId(tokenId: data.loginResult?.token ?? "");
        SharedPrefsStorage.setLoggedIn(loggedIn: true);
        emit(OnSuccessLogin());
      }
    } catch (e) {
      emit(OnFailedLogin(message: e.toString()));
    }
  }

  Future<void> doCheckLoggedIn(
    DoCheckLoggedIn event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(OnLoadingLogin());
      bool? isLoggedIn = await SharedPrefsStorage.getLoggedIn();
      if (isLoggedIn == true) {
        emit(OnSuccessLogin());
      } else {
        emit(LoginInitial());
      }
    } catch (e) {
      emit(OnFailedLogin(message: e.toString()));
    }
  }
}
