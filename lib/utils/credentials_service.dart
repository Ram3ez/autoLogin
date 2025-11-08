import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialsService {
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  final _storage = const FlutterSecureStorage();

  Future<void> saveCredentials(String username, String password) async {
    await _storage.write(key: _usernameKey, value: username);
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<Map<String, String?>> getCredentials() async {
    final username = await _storage.read(key: _usernameKey);
    final password = await _storage.read(key: _passwordKey);
    return {'username': username, 'password': password};
  }
}
