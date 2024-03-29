import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> savedata(
      {required String key, required dynamic value}) async {
    return await sharedPreferences!.setString(key, value);
  }

  static dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }
}
