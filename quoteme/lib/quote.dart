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