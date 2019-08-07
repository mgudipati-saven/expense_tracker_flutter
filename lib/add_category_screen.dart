import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_flutter/category.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expense_tracker_flutter/circular_icon_button.dart';
import 'package:expense_tracker_flutter/add_expense_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Category selectedCategory;
  String selectedItem;

  void setSelectedCategory(Category category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void setSelectedItem(String item) {
    setState(() {
      selectedItem = item;
    });
  }

  @override
  void initState() {
    super.initState();
    setSelectedCategory(Category('personal'));
    setSelectedItem(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Category')),
      body: Card(
        margin: EdgeInsets.symmetric(vertical: 32.0, horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            buildCategorySelectionPanel(),
            Expanded(child: buildItemSelectionList(),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.check),
        onPressed: selectedItem == null
          ? null
          : () async {
            final int amount = await Navigator.push<int>(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Center(child: AddExpenseScreen()),
              ),
            );

            if (amount != null && selectedItem != null) {
              Navigator.pop(context);
              final user = await _auth.currentUser();
              String path = 'users/${user.email}/expenses';
              CollectionReference collectionReference = _firestore.collection(path);
              await collectionReference.add({
                'item': selectedItem,
                'amount': amount,
                'date': Timestamp.now(),
              });

              // Update Total Balance.
              path = 'users/${user.email}';
              DocumentReference documentReference = _firestore.document(path);
              DocumentSnapshot doc = await documentReference.get();
              int balance = doc.data['balance'];
              await documentReference.updateData({
                'balance': (balance - amount),
              });
            }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildCategorySelectionPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Category('personal'),
              Category('food'),
              Category('home'),
              Category('bills'),
            ].map((Category category) {
              return CircularIconButton(
                icon: category.icon,
                color: category.color,
                label: category.name,
                isSelected: category == selectedCategory,
                onTap: () {
                  setSelectedCategory(category);
                },
              );
            }).toList(),
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Category('cloth'),
              Category('fun'),
              Category('transport'),
              Category('misc')
            ].map((Category category) {
              return CircularIconButton(
                icon: category.icon,
                color: category.color,
                label: category.name,
                isSelected: category == selectedCategory,
                onTap: () {
                  setSelectedCategory(category);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildItemSelectionList() {
    final List<String> items = selectedCategory.items;

    return Container(
      color: Color(0xFFFAFBFD),
      child: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              items[index],
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              selectedItem == items[index]
                  ? FontAwesomeIcons.solidCheckCircle
                  : FontAwesomeIcons.circle,
              color: Colors.green,
              size: 32.0,
            ),
            onTap: () {
              setSelectedItem(items[index]);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
