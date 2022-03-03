import 'package:shared_preferences/shared_preferences.dart';

class StorageService{

  @override
  static Future saveSession(dynamic key, dynamic value) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    print('session saved');
  }

  @override
  static Future readSession(dynamic key) async{
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    return value;
  }

  @override
  static Future exitSession(key) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, '');
    print('session exited !');
  }
}