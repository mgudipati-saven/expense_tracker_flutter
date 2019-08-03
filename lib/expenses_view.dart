import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_flutter/add_category_screen.dart';
import 'package:expense_tracker_flutter/category.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_flutter/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpensesView extends StatefulWidget {
  ExpensesView({this.uuid});

  final String uuid;

  @override
  _ExpensesViewState createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  final Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildBody(context),
            FloatingActionButton(
              child: Icon(FontAwesomeIcons.plus),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddCategoryScreen(),
                  ),
                );

                print('Return value from AddCategoryScreen: $result');

//                String path = 'users/${widget.uuid}/expenses';
//                CollectionReference ref = _firestore.collection(path);
//                await ref.add({
//                  'item': result,
//                  'amount': 100,
//                  'date': Timestamp.now(),
//                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    print('${widget.uuid}');
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users')
            .document('${widget.uuid}').collection('expenses').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          print(snapshot);
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
