import 'quote_model.dart';

class QuoteResponseModel {
  final List<QuoteModel> quotes;

  const QuoteResponseModel({required this.quotes});

  factory QuoteResponseModel.fromJson(Map<String, dynamic> json) {
    final list = json['quotes'] as List<dynamic>? ?? [];
    return QuoteResponseModel(
      quotes: list
          .map((item) => QuoteModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quotes': quotes.map((q) => q.toJson()).toList(),
    };
  }
}
