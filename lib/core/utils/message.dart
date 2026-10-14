class Messages {
  final Map<String, Map<String, String>> languages;
  Messages({required this.languages});

  Map<String, Map<String, String>> get keys {
    return languages;
  }
}