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
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFCEAE8),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(30.0)),
                ),
                child: Image.asset('images/logo.png')
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                      elevation: 8.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(24.0, 12.0, 8.0, 8.0),
                            hintText: 'Username',
                            suffixIcon: Icon(FontAwesomeIcons.user, color: Colors.red),
                            border: InputBorder.none,
                         ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      elevation: 8.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(24.0, 12.0, 8.0, 8.0),
                            hintText: 'Password',
                            suffixIcon: Icon(FontAwesomeIcons.key, color: Colors.red),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                            Color(0xFF0F54633),
                            Color(0xFF61269E),
                          ],
                        ),
                      ),
                      child: FlatButton(
                        onPressed: () {},
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Login With',
                          style: TextStyle(
                            color: Colors.grey.shade600
                          ),
                        ),
                        SizedBox(width: 16.0),
                        CircularIconButton(
                          color: Color(0xFF315DBB),
                          icon: FontAwesomeIcons.facebookF,
                          onPressed: () async {
                          },
                        ),
                        SizedBox(width: 16.0),
                        CircularIconButton(
                          color: Color(0xFFE2483B),
                          icon: FontAwesomeIcons.google,
                          onPressed: () async {
                            try {
                              await handleSignIn();
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 32.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF622798)),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  color: Color(0xFF622798),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularIconButton extends StatelessWidget {
  CircularIconButton({this.color, this.icon, this.onPressed});

  final Color color;
  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: color,
        shape: CircleBorder(),
      ),
      child: Ink(
        child: IconButton(
          icon: Icon(icon, color: Colors.white,),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
