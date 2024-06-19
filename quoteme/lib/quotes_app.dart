import 'package:flutter/material.dart';
import 'quotes_page.dart';

void main() => runApp(QuotesApp());

class QuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF353A47)
      ),
      home: QuotesPage(),
    );
  }
}
