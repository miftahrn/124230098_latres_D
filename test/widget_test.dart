import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:latres/main.dart';
import 'package:latres/services/auth_service.dart';

void main() {
  testWidgets('shows the login screen when there is no session',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MyApp(authService: AuthService(preferences)),
    );

    expect(find.text('Latres Store'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
