import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String item;
  final String category;
  final int amount;
  final DateTime date;

  Expense({this.item, this.category, this.amount, this.date});

  factory Expense.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Expense(
      item: data['item'] ?? '',
      category: data['category'] ?? '',
      amount: data['amount'] ?? 0,
      date: data['date'] == null ? DateTime.now() : data['date'].toDate(),
    );
  }
}