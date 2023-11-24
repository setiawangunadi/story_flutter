part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetListStory extends HomeEvent {
  final int location;

  GetListStory({required this.location});
}

class DoLogout extends HomeEvent {}
