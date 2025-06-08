import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static Future<void> saveLogin(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  static Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
  }
}