import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat/providers/providers.dart';
import 'package:SmartBudget/fintracker/app.dart';
import 'package:SmartBudget/fintracker/bloc/cubit/app_cubit.dart';
import 'package:SmartBudget/fintracker/helpers/db.helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Shared Preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Initialize Database
  await getDBInstance();
  AppState appState = await AppState.getState();

  // Initialize Firestore and Firebase Storage
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  runApp(MyApp(
      prefs: prefs,
      appState: appState,
      firebaseFirestore: _firebaseFirestore,
      firebaseStorage: _firebaseStorage));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final AppState appState;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  MyApp(
      {required this.prefs,
      required this.appState,
      required FirebaseFirestore firebaseFirestore,
      required FirebaseStorage firebaseStorage})
      : _firebaseFirestore = firebaseFirestore,
        _firebaseStorage = firebaseStorage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Providers from the first project
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            firebaseAuth: FirebaseAuth.instance,
            googleSignIn: GoogleSignIn(),
            prefs: this.prefs,
            firebaseFirestore: this._firebaseFirestore,
          ),
        ),
        Provider<SettingProvider>(
          create: (_) => SettingProvider(
            prefs: this.prefs,
            firebaseFirestore: this._firebaseFirestore,
            firebaseStorage: this._firebaseStorage,
          ),
        ),
        Provider<HomeProvider>(
          create: (_) => HomeProvider(
            firebaseFirestore: this._firebaseFirestore,
          ),
        ),
        Provider<ChatProvider>(
          create: (_) => ChatProvider(
            prefs: this.prefs,
            firebaseFirestore: this._firebaseFirestore,
            firebaseStorage: this._firebaseStorage,
          ),
        ),
        // Bloc providers from the second project
        BlocProvider<AppCubit>(
          create: (_) => AppCubit(appState),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: App(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
