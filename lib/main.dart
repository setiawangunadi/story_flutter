import 'package:flutter/material.dart';
import 'package:story_app/config/routers/router_delegate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouterDelegate myRouterDelegate;

  @override
  void initState() {
    myRouterDelegate = MyRouterDelegate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story App',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: Router(
        routerDelegate: myRouterDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
