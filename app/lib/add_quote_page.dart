import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class AddQuotePage extends StatelessWidget {
  final TextEditingController authorController = TextEditingController();
  final TextEditingController quoteController = TextEditingController();

  Future<void> addQuote(BuildContext context, String author, String quote) async {
    final url = Uri.parse('https://api-quotes.ndrew.sk/addquote'); // Update with your API endpoint

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'author': author,
          'quote': quote,
        }),
      );

      if (response.statusCode == 201) {
        // Successfully added the quote
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quote added successfully.')),
        );
        authorController.clear();
        quoteController.clear();
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add quote')),
        );
      }
    } catch (error) {
      // Handle any errors that occur during the request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding quote')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF353A47),
        iconTheme: IconThemeData(color: Color(0xFFF3F4F5)),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: authorController,
                decoration: InputDecoration(
                  hintText: 'Author',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(fontFamily: 'RammettoOne', fontSize: 16.0),
              ),
              SizedBox(height: 10.0), // Add some space before the button
              TextField(
                controller: quoteController,
                decoration: InputDecoration(
                  hintText: 'Quote',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(fontFamily: 'RammettoOne', fontSize: 16.0),
              ),
              SizedBox(height: 10.0), // Add some space before the button
              SizedBox(
                width: double.infinity, // Make the button take the full width
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF3F4F5), // Background color
                    foregroundColor: Color(0xFF353A47), // Text color
                    minimumSize: Size(double.infinity, 50), // Match the height with TextField
                    textStyle: TextStyle(
                      fontFamily: 'RammettoOne',
                      fontSize: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    final author = authorController.text;
                    final quote = quoteController.text;
                    addQuote(context, author, quote);
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}