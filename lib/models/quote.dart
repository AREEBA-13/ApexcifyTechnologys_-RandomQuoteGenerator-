class Quote {
  final String id;
  final String text;
  final String author;

  Quote({
    required this.id,
    required this.text,
    required this.author,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id']?.toString() ?? json['_id'] ?? '',
      text: json['quote'] ?? json['content'] ?? '',
      author: json['author'] ?? '',
    );
  }
}
