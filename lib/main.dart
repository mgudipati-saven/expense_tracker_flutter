import 'package:flutter/material.dart';
import 'package:expense_tracker_flutter/expenses_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Expense Tracker';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: _buildLaunchScreen(),
    );
  }

  Widget _buildLaunchScreen() {
    return StreamBuilder<FirebaseUser>(
      stream: _auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        print(snapshot);
        if (snapshot.hasData) return ExpensesView(uuid: snapshot.data.email,);
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
    print("signed in " + user.displayName);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(child: RaisedButton(
        child: Text('Google Sign In'),
        onPressed: () async {
          try {
            FirebaseUser user = await handleSignIn();
            if (user != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ExpensesView(uuid: user.email,)
                  ),
              );
            }
          } catch (e) {
            print(e);
          }
        },
      ),),
    );
  }
}
