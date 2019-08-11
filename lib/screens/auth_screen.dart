import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

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