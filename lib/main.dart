import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_to_list_app/TaskListScreen.dart';

/// The main entry point of the Flutter application.
void main() async {
  // Ensures that widget binding is initialized before using Firebase or other services
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization for web platform with specific options
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDGAdZC2vNygKmnezsVhVbrDem6pAtICes", // Web API key
        authDomain: "enzigma-78ca5.firebaseapp.com",       // Firebase Auth domain
        projectId: "enzigma-78ca5",                         // Firebase project ID
        storageBucket: "enzigma-78ca5.firebasestorage.app",// Firebase Storage bucket
        messagingSenderId: "275667321928",                  // Messaging sender ID (for FCM)
        appId: "1:275667321928:web:cf7d04fc3171122c3b447d", // App ID for web
      ),
    );
  } else {
    // Firebase initialization for mobile (Android/iOS) — uses native configuration
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

/// Root widget of the app, responsible for setting up the MaterialApp.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'To-Do List',              
      home: TaskListScreen(),           
    );
  }
}
