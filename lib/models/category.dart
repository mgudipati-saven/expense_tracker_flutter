import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final Color color;
  final IconData icon;
  final List<dynamic> items;

  Category({
    @required this.id,
    @required this.name,
    @required this.color,
    @required this.icon,
    @required this.items,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Category(
      id: doc.documentID,
      name: data['name'] ?? 'Misc',
      color: getColor(doc.documentID),
      icon: getIcon(doc.documentID),
      items: data['items'] ?? [],
    );
  }

  static IconData getIcon(String category) {
    return _iconDict[category] ?? _iconDict['Misc'];
  }

  static Color getColor(String category) {
    return _colorDict[category] ?? _colorDict['Misc'];
  }

  static final Map<String, IconData> _iconDict = {
    'Personal': FontAwesomeIcons.user,
    'Food': FontAwesomeIcons.utensils,
    'Home': FontAwesomeIcons.home,
    'Fun': FontAwesomeIcons.cocktail,
    'Bills': FontAwesomeIcons.receipt,
    'Transport': FontAwesomeIcons.car,
    'Cloth': FontAwesomeIcons.tshirt,
    'Misc': FontAwesomeIcons.gift,
  };

  static final Map<String, Color> _colorDict = {
    'Personal': Colors.black,
    'Food': Colors.green,
    'Home': Colors.yellow,
    'Fun': Colors.red,
    'Bills': Colors.green,
    'Transport': Colors.amber,
    'Cloth': Colors.lightBlue,
    'Misc': Colors.brown,
  };
}