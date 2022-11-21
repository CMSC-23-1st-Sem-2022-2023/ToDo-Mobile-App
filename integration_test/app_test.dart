import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:week7_networking_discussion/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test', () {
    testWidgets('Test Signup button', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final loginButton = find.byKey(const Key("loginButton"));
      final screenDisplay = find.text('Sign Up');
      final userNameField = find.byKey(const Key("emailField"));
      final passwordField = find.byKey(const Key("pwField"));
      final signUpButton = find.byKey(const Key("signUpButton"));

      expect(screenDisplay, findsOneWidget);
      expect(userNameField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);
      expect(signUpButton, findsOneWidget);

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      final todoScreen = find.text('Todo');

      expect(todoScreen, findsOneWidget);
    });
  });
}
