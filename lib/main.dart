import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:expense_tracker_flutter/screens/auth_screen.dart';
import 'package:expense_tracker_flutter/screens/expenses_screen.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

void main() {
  runApp(MyApp());
}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Expense Tracker';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
      ],
      child: MaterialApp(
        title: _title,
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: Color(0xFFEAEEF9),
          appBarTheme: AppBarTheme(color: Color(0xFF64619C)),
          floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
            backgroundColor: Color(0xFF5EC4AC),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }

//  Widget _buildLaunchScreen() {
//    return StreamBuilder<FirebaseUser>(
//      stream: _auth.onAuthStateChanged,
//      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
//        if (snapshot.hasData) return ExpensesScreen(user: snapshot.data);
//        return AuthScreen();
//      },
//    );
//  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return user == null ? AuthScreen() : ExpensesScreen(user: user);
  }
}


