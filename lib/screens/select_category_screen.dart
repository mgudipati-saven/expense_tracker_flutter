import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:expense_tracker_flutter/models/category.dart';
import 'package:expense_tracker_flutter/widgets/circular_icon_button.dart';

class SelectCategoryScreen extends StatefulWidget {
  @override
  _SelectCategoryScreenState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  String selectedCategory;
  String selectedItem;
  var categories;

  void setSelectedCategory(String category) {
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
    setSelectedCategory('Personal');
    setSelectedItem(null);
  }

  @override
  Widget build(BuildContext context) {
    categories = Provider.of<List<Category>>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Add Category')),
      body: Card(
        margin: EdgeInsets.symmetric(vertical: 32.0, horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 1, child: buildCategorySelectionGrid(categories)),
            Expanded(flex: 2, child: buildItemSelectionList(),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.check),
        onPressed: selectedItem == null
          ? null
          : () {
            Navigator.pop(context, [selectedItem, selectedCategory]);
          },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  Widget buildCategorySelectionGrid(List<Category> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.horizontal,
        childAspectRatio: 1.12,
        children: categories.map((Category category) {
          return CircularIconButton(
            icon: category.icon,
            color: category.color,
            label: category.name,
            isSelected: category.name == selectedCategory,
            onTap: () {
              setSelectedCategory(category.name);
            },
          );
        }).toList(),
      ),
    );
  }

//  Widget buildCategorySelectionPanel() {
//    return Padding(
//      padding: const EdgeInsets.symmetric(vertical: 8.0),
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: [
//              Category('personal'),
//              Category('food'),
//              Category('home'),
//              Category('bills'),
//            ].map((Category category) {
//              return CircularIconButton(
//                icon: category.icon,
//                color: category.color,
//                label: category.name,
//                isSelected: category == selectedCategory,
//                onTap: () {
//                  setSelectedCategory(category);
//                },
//              );
//            }).toList(),
//          ),
//          SizedBox(height: 10.0,),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: [
//              Category('cloth'),
//              Category('fun'),
//              Category('transport'),
//              Category('misc')
//            ].map((Category category) {
//              return CircularIconButton(
//                icon: category.icon,
//                color: category.color,
//                label: category.name,
//                isSelected: category == selectedCategory,
//                onTap: () {
//                  setSelectedCategory(category);
//                },
//              );
//            }).toList(),
//          ),
//        ],
//      ),
//    );
//  }

  Widget buildItemSelectionList() {
    List<dynamic> items = [];
    for (Category category in categories) {
      if (category.id == selectedCategory) {
        items = category.items;
      }
    }

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
