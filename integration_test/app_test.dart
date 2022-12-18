import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:week7_networking_discussion/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test', () {
    testWidgets('Test Signup button', (tester) async {
      //flutter test integration_test/app_test.dart
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

      final addButton = find.byKey(const Key("addButton"));
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      final addModal = find.text('Add new todo');
      expect(addModal, findsOneWidget);

      /* final friends = find.byKey(const Key("friends"));
      await tester.tap(friends);

      final friendScreen = find.text('Friends');
      expect(friendScreen, findsOneWidget);

      NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pump();

      await tester.dragFrom(
          tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));
      await tester.pumpAndSettle();

      final profile = find.byKey(const Key("profile"));
      await tester.tap(profile);
      await tester.pumpAndSettle();

      final profileScreen = find.text('Profile');
      expect(profileScreen, findsOneWidget);

      await tester.dragFrom(
          tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));
      await tester.pumpAndSettle();

      final logoutButton = find.byKey(const Key("logout"));
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      final loginScreen = find.text('Login');
      expect(loginScreen, findsOneWidget); */
    });
  });
}
