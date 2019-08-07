import 'package:expense_tracker_flutter/add_expense_screen.dart';
import 'package:expense_tracker_flutter/add_income_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:expense_tracker_flutter/category.dart';
import 'package:expense_tracker_flutter/constants.dart';
import 'package:expense_tracker_flutter/rounded_button.dart';
import 'package:expense_tracker_flutter/expense.dart';

class ExpensesView extends StatefulWidget {
  ExpensesView({this.user});

  final FirebaseUser user;

  @override
  _ExpensesViewState createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DateTime selectedDate, today;
  Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.now();
    today = DateTime(date.year, date.month, date.day);
    setSelectedDate(today);
  }

  void setSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
      _stream = _firestore
        .collection('users')
        .document('${widget.user.email}')
        .collection('expenses')
        .where('date', isEqualTo: Timestamp.fromDate(date))
        .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Container(
          color: Color(0xFF5EC4AC),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(widget.user.displayName),
                accountEmail: Text(widget.user.email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.photoUrl),
                ),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.moneyCheckAlt, color: Colors.white),
                title: Text('Income', style: TextStyle(color: Colors.white, fontSize: 18.0),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AddIncomeScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.signOutAlt, color: Colors.white,),
                title: Text('Logout', style: TextStyle(color: Colors.white, fontSize: 18.0),),
                onTap: () {
                  _auth.signOut();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Total Balance',
          style: TextStyle(
            fontWeight: FontWeight.normal
          ),
        ),
        bottom: _buildAppBarBottom(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildButtonsRow(),
          _buildListView(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () async {
          Expense expense = await Navigator.push<Expense>(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddExpenseScreen(),
            ),
          );

          if (expense != null) {
            String path = 'users/${widget.user.email}/expenses';
            CollectionReference collectionReference = _firestore.collection(path);
            await collectionReference.add({
              'item': expense.item,
              'amount': expense.amount,
              'date': Timestamp.fromDate(selectedDate),
            });

            // Update Total Balance.
            path = 'users/${widget.user.email}';
            DocumentReference documentReference = _firestore.document(path);
            DocumentSnapshot doc = await documentReference.get();
            int balance = doc.data['balance'];
            await documentReference.updateData({
              'balance': (balance - expense.amount),
            });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildButtonsRow() {
    DateTime todayMinus1 = today.subtract(Duration(days: 1));
    DateTime todayMinus2 = today.subtract(Duration(days: 2));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new RoundedButton(
            text: DateFormat("EEE").format(todayMinus2),
            selected: selectedDate == todayMinus2 ? true : false,
            onTap: () {
              setSelectedDate(todayMinus2);
            },
          ),
          new RoundedButton(
            text: DateFormat("EEE").format(todayMinus1),
            selected: selectedDate == todayMinus1 ? true : false,
            onTap: () {
              setSelectedDate(todayMinus1);
            },
          ),
          new RoundedButton(
            text: 'Today',
            selected: selectedDate == today ? true : false,
            onTap: () {
              setSelectedDate(today);
            },
          ),
        ],
      ),
    );
  }

  PreferredSize _buildAppBarBottom() {
    Widget balanceAmountText = StreamBuilder(
      stream: _firestore
          .collection('users')
          .document('${widget.user.email}')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return Text('...');
        snapshot.data.data.forEach((key, value) {
        });
        return Text(
          snapshot.data['balance'].toString(),
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.white,
            fontWeight: FontWeight.w600
          ),
        );
      },
    );

    return PreferredSize(
      preferredSize: Size.fromHeight(20.0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: balanceAmountText,
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot expense = snapshot.data.documents[index];
              Category category = Category.getCategory(expense['item']);
              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(14.0),
                  decoration: ShapeDecoration(
                    shape: CircleBorder(
                      side: BorderSide(
                        color: category.color,
                        width: 2.0
                      ),
                    ),
                  ),
                  child: Icon(
                    category.icon,
                    size: 26.0,
                  ),
                ),
                title: Text(
                  category.name,
                  style: kTitleTextStyle,
                ),
                subtitle: Text(
                  expense['item'],
                  style: kSubtitleTextStyle,
                ),
                trailing: Text(
                  '\$${expense['amount'].round()}',
                  style: kNumberTextStyle,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          );
        },
      ),
    );
  }
}
