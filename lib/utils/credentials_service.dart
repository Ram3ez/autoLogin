import 'package:shared_preferences/shared_preferences.dart';

class CredentialsService {
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';

  Future<void> saveCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
  }

  Future<Map<String, String?>> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_usernameKey);
    final password = prefs.getString(_passwordKey);
    return {'username': username, 'password': password};
  }
}
