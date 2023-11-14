import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage {
  static const String kTokenId = "tokenId";
  static const String kSessionId = "sessionId";
  static const String kDestinationId = "destinationId";
  static const String kAmount = "amount";
  static const String kSourceName = "accountSrcName";
  static const String kDestinationName = "accountDstName";
  static const String kInquiryId = "inquiryId";
  static const String kStatusCode = "statusCode";
  static const String kStatusMessage = "statusMessage";

  static Future<SharedPreferences> get sharedPrefs =>
      SharedPreferences.getInstance();

  //TokenId
  static Future<String?> getTokenId() async =>
      (await sharedPrefs).getString(kTokenId);

  static Future setTokenId({required String tokenId}) async =>
      (await sharedPrefs).setString(kTokenId, tokenId);

  static Future clearTokenId() async => (await sharedPrefs).remove(kTokenId);

  static Future clearAll() async {
    (await sharedPrefs).remove(kTokenId);
  }
}
