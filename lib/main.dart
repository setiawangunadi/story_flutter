import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:story_app/config/routers/router_delegate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Location location = Location();
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      print("Location services is not available");
      return;
    }
  }
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      print("Location permission is denied");
      return;
    }
  }

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
