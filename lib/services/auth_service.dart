import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

class AuthService {
  const AuthService(this._preferences);

  final SharedPreferences _preferences;

  bool get isLoggedIn => _preferences.getBool(AppConfig.loggedInKey) ?? false;

  String? get username => _preferences.getString(AppConfig.usernameKey);

  Future<bool> login(String username, String password) async {
    if (username.trim().isEmpty || password != AppConfig.studentNim) {
      return false;
    }
    await _preferences.setBool(AppConfig.loggedInKey, true);
    await _preferences.setString(AppConfig.usernameKey, username.trim());
    return true;
  }

  Future<void> logout() async {
    await _preferences.remove(AppConfig.loggedInKey);
    await _preferences.remove(AppConfig.usernameKey);
  }
}
