import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // For clipboard access
import 'add_quote_page.dart'; // Import AddQuotePage

import 'quote.dart'; // Import Quote class

class QuotesPage extends StatefulWidget {
  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  List<Quote> quotes = [];
  List<Quote> filteredQuotes = [];
  TextEditingController searchController = TextEditingController();
  bool isSearchVisible = false;

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
        filteredQuotes = quotes; // Initialize filteredQuotes with all quotes
      });
    } else {
      throw Exception('Failed to load quotes');
    }
  }

  void shuffleQuotes() {
    quotes.shuffle();
    filteredQuotes = quotes;
  }

  void searchQuotes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredQuotes = quotes;
      } else {
        filteredQuotes = quotes
            .where((quote) =>
                quote.quote.toLowerCase().contains(query.toLowerCase()) ||
                quote.author.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> copyQuote(Quote quote) async {
    final content = '"${quote.quote}" - ${quote.author}';
    await Clipboard.setData(ClipboardData(text: content));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
        titleTextStyle: TextStyle(
          fontFamily: 'RammettoOne',
          fontSize: 24.0,
          color: Color(0xFFF3F4F5),
        ),
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
            icon: Icon(Icons.search),
            color: Color(0xFFF3F4F5),
            onPressed: () {
              setState(() {
                isSearchVisible = !isSearchVisible;
                if (!isSearchVisible) {
                  searchController.clear();
                  filteredQuotes = quotes;
                }
              });
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddQuotePage()),
              );
            },
            icon: Icon(Icons.add),
            color: Color(0xFFF3F4F5),
          ),
        ],
        bottom: isSearchVisible
            ? PreferredSize(
                preferredSize: Size.fromHeight(48.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search quotes...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Color(0xFFF3F4F5), fontFamily: 'RammettoOne'),
                    ),
                    style: TextStyle(color: Color(0xFFF3F4F5), fontFamily: 'RammettoOne'),
                    onChanged: searchQuotes,
                  ),
                ),
              )
            : null,
      ),
      body: filteredQuotes.isEmpty
          ? Center(child: Text('No quotes found', style: TextStyle(color: Color(0xFFF3F4F5), fontFamily: 'RammettoOne', fontSize: 20.0)))
          : ListView.builder(
              itemCount: filteredQuotes.length,
              itemBuilder: (context, index) {
                final quote = filteredQuotes[index];
                return GestureDetector(
                  onTap: () => copyQuote(quote),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xFFF3F4F5),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '“${quote.quote}”',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'RammettoOne',
                              color: Color(0xFF353A47),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '- ${quote.author}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'RammettoOne',
                              color: Color(0xFF353A47),
                            ),
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
