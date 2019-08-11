import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:expense_tracker_flutter/screens/auth_screen.dart';
import 'package:expense_tracker_flutter/screens/expenses_screen.dart';
import 'package:expense_tracker_flutter/models/category.dart';
import 'package:expense_tracker_flutter/services/db.dart';

void main() {
  runApp(MyApp());
}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Expense Tracker';
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
        StreamProvider<List<Category>>.value(
          value: db.streamCategories(),
        ),
      ],
      child: MaterialApp(
        title: _title,
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: Color(0xFFEAEEF9),
          appBarTheme: AppBarTheme(color: Color(0xFF64619C)),
          floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
            backgroundColor: Color(0xFF5EC4AC),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return user == null ? AuthScreen() : ExpensesScreen();
  }
}


