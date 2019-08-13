import 'package:expense_tracker_flutter/screens/add_expense_screen.dart';
import 'package:expense_tracker_flutter/screens/add_income_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:expense_tracker_flutter/models/category.dart';
import 'package:expense_tracker_flutter/constants.dart';
import 'package:expense_tracker_flutter/widgets/rounded_button.dart';
import 'package:expense_tracker_flutter/models/expense.dart';
import 'package:expense_tracker_flutter/services/db.dart';

class ExpensesScreen extends StatefulWidget {
  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = DatabaseService();

  FirebaseUser user;
  DateTime selectedDate, currentDate;
  Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    selectedDate = currentDate = DateTime.now();
  }

  void setSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
      _stream = db.streamMonthlyExpenses('${user.email}', date);
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    _stream = db.streamMonthlyExpenses('${user.email}', selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Container(
          color: Color(0xFF5EC4AC),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(user.displayName),
                accountEmail: Text(user.email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
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
        bottom: _buildAppBarBottom(user),
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
              builder: (BuildContext context) => AddExpenseScreen(date: selectedDate),
            ),
          );

          if (expense != null) {
            // Add the expense
            await db.addExpense(user.email, expense);

            // Update Total Balance.
            int balance = await db.getBalance(user.email);
            await db.updateBalance(user.email, balance - expense.amount);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  DateTime updateMonth(DateTime date, int month) {
    return DateTime(
        date.year, month, date.day, date.hour,
        date.minute, date.second, date.millisecond, date.microsecond);
  }

  Widget _buildButtonsRow() {
    DateTime currentMonth = currentDate;
    DateTime previousMonth = updateMonth(currentMonth, currentMonth.month - 1);

    return Container(
      color: Color(0xFFF3F7FF),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new RoundedButton(
              text: DateFormat("MMM").format(previousMonth),
              selected: selectedDate == previousMonth ? true : false,
              onTap: () {
                setSelectedDate(previousMonth);
              },
            ),
            new RoundedButton(
              text: DateFormat("MMM").format(currentMonth),
              selected: selectedDate == currentMonth ? true : false,
              onTap: () {
                setSelectedDate(currentMonth);
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSize _buildAppBarBottom(FirebaseUser user) {
    Widget balanceAmountText = StreamBuilder(
        stream: db.streamUser('${user.email}'),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return Text('...');
        snapshot.data.data.forEach((key, value) {
        });
        return Text(
          '\$ ${snapshot.data['balance']}',
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
              final Expense expense = Expense.fromFirestore(snapshot.data.documents[index]);
              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(14.0),
                  decoration: ShapeDecoration(
                    shape: CircleBorder(
                      side: BorderSide(
                        color: Category.getColor(expense.category),
                        width: 2.0
                      ),
                    ),
                  ),
                  child: Icon(
                    Category.getIcon(expense.category),
                    size: 26.0,
                  ),
                ),
                title: Text(
                  expense.category,
                  style: kTitleTextStyle,
                ),
                subtitle: Text(
                  expense.item,
                  style: kSubtitleTextStyle,
                ),
                trailing: Text(
                  '\$${expense.amount.round()}',
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
