part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetListStory extends HomeEvent {
  final int location;
  final int page;
  final int size;

  GetListStory({
    required this.location,
    required this.page,
    required this.size,
  });
}

class DoLogout extends HomeEvent {}
