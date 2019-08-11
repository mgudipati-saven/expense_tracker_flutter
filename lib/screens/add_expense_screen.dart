import 'package:expense_tracker_flutter/screens/select_category_screen.dart';
import 'package:expense_tracker_flutter/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expense_tracker_flutter/constants.dart';

class AddExpenseScreen extends StatefulWidget {
  AddExpenseScreen({this.date});

  final DateTime date;

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String amount = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
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
            final String item = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Center(child: SelectCategoryScreen()),
              ),
            );

            if (item != null) {
              Expense expense = Expense(item: item, amount: int.parse(amount), date: widget.date);
              Navigator.pop(context, expense);
            }
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
