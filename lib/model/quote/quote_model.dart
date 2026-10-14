class QuoteModel {
  final String id;
  final String author;
  final String quote;

  const QuoteModel({
    required this.id,
    required this.author,
    required this.quote,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String? ?? '',
      author: json['author'] as String? ?? '',
      quote: json['quote'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'quote': quote,
    };
  }
}
