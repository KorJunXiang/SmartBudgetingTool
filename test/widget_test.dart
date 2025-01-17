// This is a basic Flutter widgets test.
// To perform an interaction with a widgets in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widgets tree, read text, and verify that the values of widgets properties
// are correct.

import 'package:SmartBudget/fintracker/bloc/cubit/app_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:SmartBudget/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppState appState = await AppState.getState();

    // Initialize Firestore and Firebase Storage
    final _firebaseFirestore = FirebaseFirestore.instance;
    final _firebaseStorage = FirebaseStorage.instance;
    await tester.pumpWidget(new MyApp(
        prefs: prefs,
        appState: appState,
        firebaseFirestore: _firebaseFirestore,
        firebaseStorage: _firebaseStorage));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
