import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/blocs/home/home_bloc.dart';
import 'package:story_app/blocs/login/login_bloc.dart';
import 'package:story_app/blocs/register/register_bloc.dart';
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
                child: const HomeScreen(),
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
          });
          return true;
        },
      ),
    );
  }
}
