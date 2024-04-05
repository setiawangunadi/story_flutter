import 'dart:async';

import 'package:flutter/foundation.dart';

class PageManager extends ChangeNotifier {
  late Completer<List<dynamic>> _completer;

  Future<List<dynamic>> waitForResult() async {
    _completer = Completer<List<dynamic>>();
    return _completer.future;
  }

  void returnData(List<dynamic> value) {
    _completer.complete(value);
  }
}