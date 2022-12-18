import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/main.dart' as app;

void main() {
  // Define a test
  testWidgets('Test Signup Widget', (tester) async {
    // Create the widget by telling the tester to build it along with the provider the widget requires

    app.main();
//find the widgets by the text or by their keys
    // Go to sign up page
    final signUpButton = find.byKey(const Key("signUpButton"));
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    final screenDisplay = find.text('Sign Up');
    final firstNameField = find.byKey(const Key("fName"));
    final bdayField = find.byKey(const Key("bday"));
    final locationField = find.byKey(const Key("locationField"));
    final bioField = find.byKey(const Key("bioField"));
    final emailField = find.byKey(const Key("sEmail"));
    final passwordField = find.byKey(const Key("passwordField"));
    final signupButton2 = find.byKey(const Key("signUp"));
    final backButton = find.byKey(const Key("back"));

    expect(screenDisplay, findsOneWidget);
    expect(firstNameField, findsOneWidget);
    expect(bdayField, findsOneWidget);
    expect(locationField, findsOneWidget);
    expect(bioField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(emailField, findsOneWidget);
    expect(signupButton2, findsOneWidget);
    expect(backButton, findsOneWidget);
  });

  testWidgets('Test Sign Up error Widget', (tester) async {
    // Create the widget by telling the tester to build it along with the provider the widget requires

    app.main();
//find the widgets by the text or by their keys
    // Go to sign up page
    final signUpButton = find.byKey(const Key("signUpButton"));
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    final signupButton2 = find.byKey(const Key("signUp"));
    await tester.pumpAndSettle();
    await tester.tap(signupButton2);
    await tester.pumpAndSettle();

    // Check if the error texts appear
    final screenDisplay = find.text('Sign Up');
    final firstNameError = find.text('Enter name');
    final bio = find.text('Enter bio');
    final location = find.text('Enter location');
    final emailError = find.text('Enter valid email address');
    final passwordError = find.text('Password must be atleast 6');

    expect(screenDisplay, findsOneWidget);
    expect(firstNameError, findsOneWidget);
    expect(bio, findsOneWidget);
    expect(location, findsOneWidget);
    expect(emailError, findsOneWidget);
    expect(passwordError, findsOneWidget);
  });

  testWidgets('Test login Widget', (tester) async {
    app.main();
    //find the widgets by the text or by their keys
    // Check login page
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

  testWidgets(
      'non-empty first name, last name, valid email and password, calls sign up, succeeds',
      (tester) async {
    app.main();

    final signUpButton = find.byKey(const Key("signUpButton"));
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    final firstNameField = find.byKey(const Key("fName"));
    await tester.enterText(firstNameField, 'rox');
    await tester.pump(Duration(milliseconds: 400));

    final locationField = find.byKey(const Key("locationField"));
    await tester.enterText(locationField, 'Batangas');
    await tester.pump(Duration(milliseconds: 400));

    final bioField = find.byKey(const Key("bioField"));
    await tester.enterText(bioField, 'hi');
    await tester.pump(Duration(milliseconds: 400));

    final emailField = find.byKey(const Key("sEmail"));
    await tester.enterText(emailField, 'rox@gmail.com');
    await tester.pump(Duration(milliseconds: 400));

    final passwordField = find.byKey(const Key("passwordField"));
    await tester.enterText(passwordField, '123123');
    await tester.pump(Duration(milliseconds: 400));

    final signupButton = find.byKey(const Key("signUp"));
    await tester.tap(signupButton);

    await tester.pumpAndSettle();

    final todoScreen = find.text('Todo');
    expect(todoScreen, findsOneWidget);
  });

  testWidgets('Test add button', (tester) async {
    app.main();

    final loginButton = find.byKey(const Key("loginButton"));
    await tester.tap(loginButton);

    await tester.pumpAndSettle();

    final todoScreen = find.text('Todo');
    expect(todoScreen, findsOneWidget);

    final addButton = find.byKey(const Key("addButton"));
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    final addModal = find.text('Add new todo');
    expect(addModal, findsOneWidget);
  });

  testWidgets('Test logout button', (tester) async {
    app.main();

    final loginButton = find.byKey(const Key("loginButton"));
    await tester.tap(loginButton);

    await tester.pumpAndSettle();

    final todoScreen = find.text('Todo');
    expect(todoScreen, findsOneWidget);

    await tester.dragFrom(
        tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));
    await tester.pumpAndSettle();

    final logoutButton = find.byType(ListTile).last;
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    final loginScreen = find.text('Login');
    expect(loginScreen, findsOneWidget);
  });
}
