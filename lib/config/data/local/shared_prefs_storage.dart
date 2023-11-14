import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage {
  static const String kTokenId = "tokenId";
  static const String kLoggedIn = "loggedIn";

  static Future<SharedPreferences> get sharedPrefs =>
      SharedPreferences.getInstance();

  //TokenId
  static Future<String?> getTokenId() async =>
      (await sharedPrefs).getString(kTokenId);

  static Future setTokenId({required String tokenId}) async =>
      (await sharedPrefs).setString(kTokenId, tokenId);

  static Future clearTokenId() async => (await sharedPrefs).remove(kTokenId);

  //LoggedIn
  static Future<bool?> getLoggedIn() async =>
      (await sharedPrefs).getBool(kLoggedIn);

  static Future setLoggedIn({required bool loggedIn}) async =>
      (await sharedPrefs).setBool(kLoggedIn, loggedIn);

  static Future clearLoggedIn() async => (await sharedPrefs).remove(kLoggedIn);

  static Future clearAll() async {
    (await sharedPrefs).remove(kTokenId);
  }
}
