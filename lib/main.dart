import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Expense Tracker';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: CategorySelectionScreen(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(FontAwesomeIcons.check),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class CategorySelectionScreen extends StatefulWidget {
  @override
  _CategorySelectionScreenState createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
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
    setSelectedCategory(Category.personal);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          buildCategorySelectionPanel(),
          Expanded(child: buildItemSelectionList(),),
        ],
      ),
    );
  }

  Widget buildCategorySelectionPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Category.personal,
                Category.food,
                Category.home,
                Category.bills,
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
                Category.cloth,
                Category.fun,
                Category.transport,
                Category.misc
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
      ),
    );
  }

  Widget buildItemSelectionList() {
    final List<String> items = selectedCategory.items;

    return Card(
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

class CircularIconButton extends StatelessWidget {
  CircularIconButton({
    @required this.icon,
    @required this.color,
    @required this.isSelected,
    @required this.label,
    @required this.onTap,
  });

  final IconData icon;
  final Color color;
  final bool isSelected;
  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Ink(
            decoration: ShapeDecoration(
              color: isSelected ? color : null,
              shape: CircleBorder(
                side: BorderSide(color: color, width: 2.0),
              ),
            ),
            child: IconButton(
              alignment: Alignment.center,
              padding: EdgeInsets.all(22.0),
              icon: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 32.0,
              ),
              onPressed: onTap,
            ),
          ),
          SizedBox(height: 5.0,),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class Category {
  static const Category food = Category(
    name: 'Food',
    color: Colors.green,
    icon: FontAwesomeIcons.utensils,
    items: ['Restaurant', 'Pizza', 'Others'],
  );

  static const Category personal = Category(
    name: 'Personal',
    color: Colors.blue,
    icon: FontAwesomeIcons.user,
    items: ['Mobile', 'Medicine', 'Others'],
  );

  static const Category home = Category(
    name: 'Home',
    color: Colors.yellow,
    icon: FontAwesomeIcons.home,
    items: ['Furniture', 'Repairs', 'Others'],
  );

  static const Category fun = Category(
    name: 'Fun',
    color: Colors.red,
    icon: FontAwesomeIcons.cocktail,
    items: ['Nightclub', 'Games', 'Cinema', 'Others'],
  );

  static const Category bills = Category(
    name: 'Bills',
    color: Colors.lightGreen,
    icon: FontAwesomeIcons.receipt,
    items: ['Telephone', 'Utilities', 'Electricity', 'Credit Card', 'Others'],
  );

  static const Category transport = Category(
    name: 'Transport',
    color: Colors.purple,
    icon: FontAwesomeIcons.car,
    items: ['Cab', 'Taxi', 'Bus', 'Train', 'Others'],
  );

  static const Category cloth = Category(
    name: 'Cloth',
    color: Colors.brown,
    icon: FontAwesomeIcons.tshirt,
    items: ['Shirts', 'Dresses', 'Shoes', 'Others'],
  );

  static const Category misc = Category(
    name: 'Misc',
    color: Colors.black,
    icon: FontAwesomeIcons.gift,
    items: ['Charity', 'Donation', 'Lost', 'Others'],
  );

  const Category({
    @required this.name,
    @required this.color,
    @required this.icon,
    @required this.items,
  });

  final String name;
  final Color color;
  final IconData icon;
  final List<String> items;
}