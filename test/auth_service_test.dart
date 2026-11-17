import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:latres/config/app_config.dart';
import 'package:latres/services/auth_service.dart';

void main() {
  test('logs in with any username and the configured NIM', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final service = AuthService(preferences);

    final result = await service.login('user-a', AppConfig.studentNim);

    expect(result, isTrue);
    expect(service.isLoggedIn, isTrue);
    expect(service.username, 'user-a');
  });

  test('rejects an incorrect password and clears session on logout', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final service = AuthService(preferences);

    expect(await service.login('user-a', 'wrong-password'), isFalse);
    expect(service.isLoggedIn, isFalse);

    await service.login('user-a', AppConfig.studentNim);
    await service.logout();

    expect(service.isLoggedIn, isFalse);
    expect(service.username, isNull);
  });

  test('keeps the session when the service is recreated', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final firstService = AuthService(preferences);

    await firstService.login('user-a', AppConfig.studentNim);
    final reopenedService = AuthService(
      await SharedPreferences.getInstance(),
    );

    expect(reopenedService.isLoggedIn, isTrue);
    expect(reopenedService.username, 'user-a');
  });
}
