class AppRatingRequest {
  final int rating;
  final String review;

  const AppRatingRequest({
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'review': review,
  };
}

class AppRatingData {
  final String? message;
  const AppRatingData({this.message});
}

class AppRatingResult {
  final bool isSuccess;
  final String? errorMessage;
  final AppRatingData? dataOrNull;

  const AppRatingResult({
    required this.isSuccess,
    this.errorMessage,
    this.dataOrNull,
  });
}
