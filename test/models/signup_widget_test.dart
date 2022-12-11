import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/main.dart' as app;

void main() {
  // Test for computing an area
  test('Test for getting the area of a rectangle', () {
    double length = 3.00;
    double width = 4.00;

    // area = length * width
    double area = length * width;
    expect(area, 12.00);
  });

  testWidgets('Screen has a title and body', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MaterialApp(
        title: 'TEST',
        home: Scaffold(
          body: Text("HI"),
        )));

    // Create the Finders.
    final titleFinder = find.text('TEST');
    final bodyFinder = find.text('HI');

    // verify that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(bodyFinder, findsOneWidget);
  });

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
    final lastNameField = find.byKey(const Key("lName"));
    final emailField = find.byKey(const Key("sEmail"));
    final passwordField = find.byKey(const Key("sPass"));
    final signupButton2 = find.byKey(const Key("signUp"));
    final backButton = find.byKey(const Key("back"));

    expect(screenDisplay, findsOneWidget);
    expect(firstNameField, findsOneWidget);
    expect(lastNameField, findsOneWidget);
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
    final firstNameError = find.text('Enter first name');
    final lastNameError = find.text('Enter last name');
    final emailError = find.text('Enter valid email address');
    final passwordError = find.text('Password must be atleast 6');

    expect(screenDisplay, findsOneWidget);
    expect(firstNameError, findsOneWidget);
    expect(lastNameError, findsOneWidget);
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

    final lastNameField = find.byKey(const Key("lName"));
    await tester.enterText(lastNameField, 'resuello');
    await tester.pump(Duration(milliseconds: 400));

    final emailField = find.byKey(const Key("sEmail"));
    await tester.enterText(emailField, 'rox@gmail.com');
    await tester.pump(Duration(milliseconds: 400));

    final passwordField = find.byKey(const Key("sPass"));
    await tester.enterText(passwordField, '123123');
    await tester.pump(Duration(milliseconds: 400));

    final signupButton = find.byKey(const Key("signUp"));
    await tester.tap(signupButton);

    await tester.pumpAndSettle();

    final todoScreen = find.text('Todo');
    expect(todoScreen, findsOneWidget);
  });
}
