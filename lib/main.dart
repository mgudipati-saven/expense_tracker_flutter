import 'package:flutter/material.dart';
import 'package:expense_tracker_flutter/expenses_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return MaterialApp(
      title: _title,
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: Color(0xFFEAEEF9),
        appBarTheme: AppBarTheme(color: Color(0xFF64619C)),
        floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
          backgroundColor: Color(0xFF5EC4AC),
        ),
      ),
      home: _buildLaunchScreen(),
    );
  }

  Widget _buildLaunchScreen() {
    return StreamBuilder<FirebaseUser>(
      stream: _auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) return ExpensesView(user: snapshot.data);
        return AuthScreen();
      },
    );
  }
}

class AuthScreen extends StatelessWidget {
  Future<FirebaseUser> handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: FlatButton.icon(
          padding: EdgeInsets.all(12.0),
          color: Colors.red,
          textColor: Colors.white,
          icon: Icon(FontAwesomeIcons.google),
          label: Text(
            'Sign in with Google',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400
            ),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () async {
            try {
              FirebaseUser user = await handleSignIn();
//              if (user != null) {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (BuildContext context) => ExpensesView(uuid: user.email,)
//                  ),
//                );
//              }
            } catch (e) {
              print(e);
            }
          },
        ),
      ),
    );
  }
}
