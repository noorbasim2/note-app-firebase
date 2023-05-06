import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Auth/SignUp.dart';
import 'Auth/login.dart';
import 'MyHomePage.dart';
import 'crud/addNote.dart';
import 'crud/editNote.dart';

bool? isLogin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // If I had async and await in the main, so it will make sure the Initialized process was done before displaying the stateful widget
  await Firebase.initializeApp();

  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    isLogin = false;
  } else {
    isLogin = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin == false ? const SignUp() : const MyHomePage(),
      routes: {
        "login": (context) => LogIn(),
        "signUp": (context) => SignUp(),
        "homepage": (context) => MyHomePage(),
        "addNote": (context) => AddNotes(),
        "editnote": (context) => Edit_Note(),
      },
    );
  }
}
