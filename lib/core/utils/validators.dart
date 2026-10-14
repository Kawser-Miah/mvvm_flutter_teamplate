/// `TextFormField.validator` functions. Each returns null when valid.
abstract final class Validators {
  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? required(String? value, {String field = 'This field'}) =>
      (value == null || value.trim().isEmpty) ? '$field is required' : null;

  static String? email(String? value) {
    final empty = required(value, field: 'Email');
    if (empty != null) return empty;
    return _email.hasMatch(value!.trim()) ? null : 'Enter a valid email';
  }

  static String? password(String? value, {int minLength = 6}) {
    final empty = required(value, field: 'Password');
    if (empty != null) return empty;
    return value!.length < minLength
        ? 'Password must be at least $minLength characters'
        : null;
  }
}
