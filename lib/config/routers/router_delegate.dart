import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/blocs/add_story/add_story_bloc.dart';
import 'package:story_app/blocs/detail_story/detail_story_bloc.dart';
import 'package:story_app/blocs/home/home_bloc.dart';
import 'package:story_app/blocs/login/login_bloc.dart';
import 'package:story_app/blocs/register/register_bloc.dart';
import 'package:story_app/screens/add_story_screen.dart';
import 'package:story_app/screens/detail_story_screen.dart';
import 'package:story_app/screens/home_screen.dart';
import 'package:story_app/screens/login_screen.dart';
import 'package:story_app/screens/maps_screen.dart';
import 'package:story_app/screens/register_screen.dart';
import 'package:geocoding/geocoding.dart' as geo;

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  bool isClickRegister = false;
  bool isClickLogin = false;
  bool isClickAddStory = false;
  bool isClickDetailStory = false;
  bool isClickLocation = false;
  String? storyId;
  String? street;
  String? pathImage;
  String? descriptionStory;
  LatLng? location;
  geo.Placemark? placeMark;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: BlocProvider(
            create: (context) => LoginBloc(),
            child: LoginScreen(
              onTappedRegister: (bool isSelected) {
                isClickRegister = isSelected;
                notifyListeners();
              },
              onTappedLogin: (bool isSelected) {
                isClickLogin = isSelected;
                notifyListeners();
              },
            ),
          ),
        ),
        if (isClickRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: BlocProvider(
              create: (context) => RegisterBloc(),
              child: const RegisterScreen(),
            ),
          ),
        if (isClickLogin == true)
          MaterialPage(
            key: const ValueKey("HomePage"),
            maintainState: false,
            child: BlocProvider(
              create: (context) => HomeBloc(),
              child: HomeScreen(
                onTappedAddStory: (bool isSelected) {
                  isClickAddStory = isSelected;
                  notifyListeners();
                },
                onTappedLogout: (bool isSelected) {
                  isClickLogin = isSelected;
                  notifyListeners();
                },
                onTappedDetailStory: (bool isSelected, String id) {
                  isClickDetailStory = isSelected;
                  storyId = id;
                  notifyListeners();
                },
              ),
            ),
          ),
        if (isClickAddStory == true)
          MaterialPage(
            key: const ValueKey("AddStoryPage"),
            maintainState: true,
            child: BlocProvider(
              create: (context) => AddStoryBloc(),
              child: AddStoryScreen(
                locationSelected: location,
                street: street,
                path: pathImage,
                desc: descriptionStory,
                onTappedLocation:
                    (bool isSelected, String? path, String? desc) {
                  isClickLocation = isSelected;
                  notifyListeners();
                },
              ),
            ),
          ),
        if (isClickDetailStory == true)
          MaterialPage(
            key: const ValueKey("DetailStoryPage"),
            maintainState: false,
            child: BlocProvider(
              create: (context) => DetailStoryBloc(),
              child: DetailStoryScreen(id: storyId ?? ''),
            ),
          ),
        if (isClickLocation == true)
          MaterialPage(
            key: const ValueKey("MapsScreen"),
            maintainState: false,
            child: MapsScreen(
              onSaveLocation: (
                bool isSelected,
                LatLng locationSelected,
                geo.Placemark? dataLocation,
                String? path,
                String? desc,
              ) {
                isClickLocation = isSelected;
                location = locationSelected;
                street = dataLocation?.street;
                pathImage = path;
                descriptionStory = desc;
                isClickAddStory = true;
                notifyListeners();
              },
            ),
          ),
      ],
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }
        isClickRegister = false;
        isClickAddStory = false;
        isClickDetailStory = false;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}
