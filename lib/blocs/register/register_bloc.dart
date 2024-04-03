import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:story_app/config/data/exception/network.dart';
import 'package:story_app/config/data/exception/session_expired.dart';
import 'package:story_app/config/models/register_response_model.dart';
import 'package:story_app/config/repositories/register_repository.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository = RegisterRepository();

  RegisterBloc() : super(RegisterInitial()) {
    on<DoRegister>(doRegister);
  }

  Future<void> doRegister(
    DoRegister event,
    Emitter<RegisterState> emit,
  ) async {
    try {
      emit(OnLoadingRegister());
      final response = await registerRepository.doRegister(
          name: event.name, email: event.email, password: event.password);
      RegisterResponseModel data =
          RegisterResponseModel.fromJson(response.data);
      if (data.error == false) {
        emit(OnSuccessRegister(data: data));
      }
    } on Network catch (e) {
      emit(OnFailedRegister(message: e.responseMessage));
    } on SessionExpired catch (e) {
      emit(OnFailedRegister(message: e.message));
    } catch (e) {
      emit(OnFailedRegister(message: e.toString()));
    }
  }
}
