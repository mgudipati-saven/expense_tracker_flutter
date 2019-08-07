import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:expense_tracker_flutter/constants.dart';

class AddIncomeScreen extends StatefulWidget {
  @override
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String amount = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Income'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 32.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.dollarSign, color: Colors.grey, size: 32.0,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          amount,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildKeypadButton('1'),
                  _buildKeypadButton('2'),
                  _buildKeypadButton('3'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildKeypadButton('4'),
                  _buildKeypadButton('5'),
                  _buildKeypadButton('6'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildKeypadButton('7'),
                  _buildKeypadButton('8'),
                  _buildKeypadButton('9'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: SizedBox()),
                  _buildKeypadButton('0'),
                  Expanded(
                    child: IconButton(
                      iconSize: 32.0,
                      icon: Icon(FontAwesomeIcons.backspace,),
                      color: Colors.grey,
                      onPressed: () {
                        setState(() {
                          amount = amount.substring(0, amount.length-1);
                          if (amount.isEmpty) {
                            amount = '0';
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.check),
        onPressed: () async {
          try {
            FirebaseUser user = await _auth.currentUser();

            if (user != null) {
              // Update Total Balance.
              String path = 'users/${user.email}';
              DocumentReference documentReference = _firestore.document(path);
              DocumentSnapshot doc = await documentReference.get();
              int balance = doc.data['balance'];
              await documentReference.updateData({
                'balance': (balance + int.parse(amount)),
              });
            }

            Navigator.pop(context);
          } catch (e) {
            print(e);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildKeypadButton(String key) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        shape: CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            key,
            textAlign: TextAlign.end,
            style: kNumberTextStyle,
          ),
        ),
        onPressed: () {
          setState(() {
            amount = (amount == '0') ? key : (amount + key);
          });
        },
      ),
    );
  }
}
