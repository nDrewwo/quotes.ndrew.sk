import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // For clipboard access

void main() => runApp(QuotesApp());

class QuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF353A47)
      ),
      home: QuotesPage(),
    );
  }
}

class QuotesPage extends StatefulWidget {
  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  List<Quote> quotes = [];

  @override
  void initState() {
    super.initState();
    fetchQuotes();
  }

  Future<void> fetchQuotes() async {
    final response = await http.get(Uri.parse('https://api-quotes.ndrew.sk/quotes'));

    if (response.statusCode == 200) {
      setState(() {
        quotes = (json.decode(response.body) as List)
            .map((quoteJson) => Quote.fromJson(quoteJson))
            .toList();
        shuffleQuotes(); // Shuffle quotes on initial fetch
      });
    } else {
      throw Exception('Failed to load quotes');
    }
  }

  void shuffleQuotes() {
    quotes.shuffle();
  }

  Future<void> copyQuote(Quote quote) async {
    final content = '"${quote.quote}" - ${quote.author}';
    await Clipboard.setData(ClipboardData(text: content));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'), titleTextStyle: TextStyle(fontFamily: 'RammettoOne', fontSize: 24.0, color:Color(0xFFF3F4F5)),
        backgroundColor: Color(0xFF353A47),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            color: Color(0xFFF3F4F5),
            onPressed: () {
              fetchQuotes(); // Refetch and shuffle quotes
            },
          ),
          IconButton(
            onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => AddQuotePage()),
    );
            },
            icon: Icon(Icons.add),
            color: Color(0xFFF3F4F5)
          )
        ],
      ),
      body: quotes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                final quote = quotes[index];
                return GestureDetector( // Use GestureDetector for click handling
                  onTap: () => copyQuote(quote),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xFFF3F4F5)
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '“${quote.quote}”',
                            style: const TextStyle(fontSize: 16.0, fontFamily: 'RammettoOne', color: Color(0xFF353A47)),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '- ${quote.author}',
                            style: const TextStyle(fontSize: 12.0, fontFamily: 'RammettoOne', color: Color(0xFF353A47)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class AddQuotePage extends StatelessWidget {
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
                decoration: InputDecoration(
                  hintText: 'Author',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                style: TextStyle(fontFamily: 'RammettoOne', fontSize: 16.0),
              ),
              SizedBox(height: 10.0), // Add some space before the button
              TextField(
                decoration: InputDecoration(
                  hintText: 'Quote',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
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
                    // Logic to add quote
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

class Quote {
  final int id;
  final String author;
  final String quote;

  Quote({required this.id, required this.author, required this.quote});

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        id: json['id'] as int,
        author: json['author'] as String,
        quote: json['quote'] as String,
      );
}
