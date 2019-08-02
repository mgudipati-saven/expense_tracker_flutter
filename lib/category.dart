import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  static const Map<String, Category> _categoriesMap = {
    'personal': Category(
      name: 'Personal',
      color: Colors.blue,
      icon: FontAwesomeIcons.user,
      items: ['Mobile', 'Medicine', 'Others'],
    ),
    'food': Category(
      name: 'Food',
      color: Colors.green,
      icon: FontAwesomeIcons.utensils,
      items: ['Restaurant', 'Pizza', 'Others'],
    ),
    'home': Category(
      name: 'Home',
      color: Colors.yellow,
      icon: FontAwesomeIcons.home,
      items: ['Furniture', 'Repairs', 'Others'],
    ),
    'fun': Category(
      name: 'Fun',
      color: Colors.red,
      icon: FontAwesomeIcons.cocktail,
      items: ['Nightclub', 'Games', 'Cinema', 'Others'],
    ),
    'bills': Category(
      name: 'Bills',
      color: Colors.lightGreen,
      icon: FontAwesomeIcons.receipt,
      items: ['Telephone', 'Utilities', 'Electricity', 'Credit Card', 'Others'],
    ),
    'transport': Category(
      name: 'Transport',
      color: Colors.purple,
      icon: FontAwesomeIcons.car,
      items: ['Cab', 'Taxi', 'Bus', 'Train', 'Others'],
    ),
    'cloth': Category(
      name: 'Cloth',
      color: Colors.brown,
      icon: FontAwesomeIcons.tshirt,
      items: ['Shirts', 'Dresses', 'Shoes', 'Others'],
    ),
    'misc': Category(
      name: 'Misc',
      color: Colors.black,
      icon: FontAwesomeIcons.gift,
      items: ['Charity', 'Donation', 'Lost', 'Others'],
    ),
  };

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

  static Category getCategory(String itemName) {
    Category result;

    _categoriesMap.forEach((name, category) {
      category.items.forEach((item) {
        if (item == itemName) {
          result = category;
          return;
        }
      });
    });

    return result;
  }
}