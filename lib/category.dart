import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  static final Map<String, Category> _dict = {
    'personal': Category._internal(
      name: 'Personal',
      color: Colors.blue,
      icon: FontAwesomeIcons.user,
      items: ['Mobile', 'Medicine', 'Others'],
    ),
    'food': Category._internal(
      name: 'Food',
      color: Colors.green,
      icon: FontAwesomeIcons.utensils,
      items: ['Restaurant', 'Pizza', 'Others'],
    ),
    'home': Category._internal(
      name: 'Home',
      color: Colors.yellow,
      icon: FontAwesomeIcons.home,
      items: ['Furniture', 'Repairs', 'Others'],
    ),
    'fun': Category._internal(
      name: 'Fun',
      color: Colors.red,
      icon: FontAwesomeIcons.cocktail,
      items: ['Nightclub', 'Games', 'Cinema', 'Others'],
    ),
    'bills': Category._internal(
      name: 'Bills',
      color: Colors.lightGreen,
      icon: FontAwesomeIcons.receipt,
      items: ['Telephone', 'Utilities', 'Electricity', 'Credit Card', 'Others'],
    ),
    'transport': Category._internal(
      name: 'Transport',
      color: Colors.purple,
      icon: FontAwesomeIcons.car,
      items: ['Cab', 'Taxi', 'Bus', 'Train', 'Others'],
    ),
    'cloth': Category._internal(
      name: 'Cloth',
      color: Colors.brown,
      icon: FontAwesomeIcons.tshirt,
      items: ['Shirts', 'Dresses', 'Shoes', 'Others'],
    ),
    'misc': Category._internal(
      name: 'Misc',
      color: Colors.black,
      icon: FontAwesomeIcons.gift,
      items: ['Charity', 'Donation', 'Lost', 'Others'],
    ),
  };

  factory Category(String name) {
    if (_dict.containsKey(name)) {
      return _dict[name];
    } else {
      return null;
    }
  }

  Category._internal({
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

    _dict.forEach((name, category) {
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