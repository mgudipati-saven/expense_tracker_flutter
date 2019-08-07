import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_flutter/add_category_screen.dart';
import 'package:expense_tracker_flutter/category.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_flutter/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expense_tracker_flutter/rounded_button.dart';
import 'package:intl/intl.dart';

class ExpensesView extends StatefulWidget {
  ExpensesView({this.uuid});

  final String uuid;

  @override
  _ExpensesViewState createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  final Firestore _firestore = Firestore.instance;
  DateTime selectedDate, today;

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.now();
    today = selectedDate = DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddCategoryScreen(),
            ),
          );
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
              setState(() {
                selectedDate = todayMinus2;
              });
            },
          ),
          new RoundedButton(
            text: DateFormat("EEE").format(todayMinus1),
            selected: selectedDate == todayMinus1 ? true : false,
            onTap: () {
              setState(() {
                selectedDate = todayMinus1;
              });
            },
          ),
          new RoundedButton(
            text: 'Today',
            selected: selectedDate == today ? true : false,
            onTap: () {
              setState(() {
                selectedDate = today;
              });
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
          .document('${widget.uuid}')
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
        stream: _firestore
            .collection('users')
            .document('${widget.uuid}')
            .collection('expenses')
            .orderBy('date', descending: true)
            .snapshots(),
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
