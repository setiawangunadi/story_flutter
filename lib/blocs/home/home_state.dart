part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class OnLoadingHome extends HomeState {}

class OnSuccessHome extends HomeState {
  final GetStoriesResponseModel data;

  OnSuccessHome({required this.data});
}

class OnSuccessLogout extends HomeState {}

class OnFailedHome extends HomeState {
  final String message;
  final int? statusCode;

  OnFailedHome({required this.message, this.statusCode});
}
