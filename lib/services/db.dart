import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:expense_tracker_flutter/models/expense.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<DocumentSnapshot> streamUser(String id) {
    return _db
        .collection('users')
        .document(id)
        .snapshots();
  }

  Stream<QuerySnapshot> streamExpenses(String id, DateTime date) {
    return _db
        .collection('users')
        .document(id)
        .collection('expenses')
        .where('date', isEqualTo: Timestamp.fromDate(date))
        .snapshots();
  }

  Future<void> addExpense(String id, Expense expense) {
    var ref = _db.collection('users').document(id).collection('expenses');

    return ref.add({
      'item': expense.item,
      'amount': expense.amount,
      'date': Timestamp.fromDate(expense.date),
    });
  }

  Future<int> getBalance(String id) async {
    var ref = _db.collection('users').document(id);
    DocumentSnapshot doc = await ref.get();
    return doc.data['balance'];
  }

  Future<void> updateBalance(String id, int amount) async {
    var ref = _db.collection('users').document(id);
    return ref.updateData({
      'balance': amount,
    });
  }
}