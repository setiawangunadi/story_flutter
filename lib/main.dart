import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/blocs/add_story/add_story_bloc.dart';
import 'package:story_app/blocs/detail_story/detail_story_bloc.dart';
import 'package:story_app/blocs/home/home_bloc.dart';
import 'package:story_app/blocs/login/login_bloc.dart';
import 'package:story_app/blocs/register/register_bloc.dart';
import 'package:story_app/screens/add_story_screen.dart';
import 'package:story_app/screens/detail_story_screen.dart';
import 'package:story_app/screens/home_screen.dart';
import 'package:story_app/screens/login_screen.dart';
import 'package:story_app/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isClickRegister = false;
  bool isClickLogin = false;
  bool isClickAddStory = false;
  bool isClickDetailStory = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story App',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: Navigator(
        pages: [
          MaterialPage(
            key: const ValueKey("LoginPage"),
            child: BlocProvider(
              create: (context) => LoginBloc(),
              child: LoginScreen(
                onTappedRegister: (bool isSelected) {
                  setState(() {
                    isClickRegister = isSelected;
                  });
                },
                onTappedLogin: (bool isSelected) {
                  setState(() {
                    isClickLogin = isSelected;
                  });
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
                    setState(() {
                      isClickAddStory = isSelected;
                    });
                  },
                  onTappedDetailStory: (bool isSelected) {
                    setState(() {
                      isClickDetailStory = isSelected;
                    });
                  },
                ),
              ),
            ),
          if (isClickAddStory == true)
            MaterialPage(
              key: const ValueKey("AddStoryPage"),
              maintainState: false,
              child: BlocProvider(
                create: (context) => AddStoryBloc(),
                child: const AddStoryScreen(),
              ),
            ),
          if (isClickDetailStory == true)
            MaterialPage(
              key: const ValueKey("DetailStoryPage"),
              maintainState: false,
              child: BlocProvider(
                create: (context) => DetailStoryBloc(),
                child: const DetailStoryScreen(),
              ),
            ),
        ],
        onPopPage: (route, result) {
          final didPop = route.didPop(result);
          if (!didPop) {
            return false;
          }
          setState(() {
            isClickRegister = false;
            isClickAddStory = false;
          });
          return true;
        },
      ),
    );
  }
}
