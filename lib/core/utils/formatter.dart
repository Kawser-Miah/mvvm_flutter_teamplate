import 'package:flutter/material.dart';

class Formatter {
  // ──────────────────────────────────────────
  // Time
  // ──────────────────────────────────────────

  /// Formats a [TimeOfDay] or [DateTime] into "3:05 PM" format.
  /// If [showDate] is true and [dateTime] is provided, prefixes with
  /// "Yesterday at" or "12 June at".
  static String timeFormatter({
    TimeOfDay? time,
    DateTime? dateTime,
    bool showDate = false,
  }) {
    if (time == null && dateTime != null) {
      time = TimeOfDay.fromDateTime(dateTime);
    }

    if (time == null) return "";

    final buffer = StringBuffer();

    if (showDate && dateTime != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (dateOnly == today) {
        buffer.write("Today at ");
      } else if (dateOnly == yesterday) {
        buffer.write("Yesterday at ");
      } else {
        buffer.write("${dateTime.day} ${monthName(dateTime.month)} at ");
      }
    }

    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    buffer.write("$hour:${time.minute.toString().padLeft(2, '0')} ");
    buffer.write(time.period == DayPeriod.am ? "AM" : "PM");

    return buffer.toString();
  }

  // ──────────────────────────────────────────
  // Date
  // ──────────────────────────────────────────

  /// Formats a [DateTime] into "2025-06-30" (zero-padded).
  static String dateFormatter(DateTime date) {
    final y = date.year.toString();
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }

  /// Formats a [DateTime] into "30 June 2025".
  static String dateFormatterLong(DateTime date) {
    return "${date.day} ${monthName(date.month)} ${date.year}";
  }

  /// Formats a [DateTime] into "30 Jun 2025".
  static String dateFormatterShort(DateTime date) {
    return "${date.day} ${monthNameShort(date.month)} ${date.year}";
  }

  /// Returns relative date string: "Today", "Yesterday", "2 days ago", etc.
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final diff = today.difference(dateOnly).inDays;

    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    if (diff < 7) return "$diff days ago";
    if (diff < 30) return "${(diff / 7).floor()} weeks ago";
    if (diff < 365) return "${(diff / 30).floor()} months ago";
    return "${(diff / 365).floor()} years ago";
  }

  // ──────────────────────────────────────────
  // Duration
  // ──────────────────────────────────────────

  /// Formats a [Duration] into "MM:SS" countdown format.
  static String countdown(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  /// Formats a [Duration] into "HH:MM:SS" countdown format.
  static String countdownLong(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  /// Formats a [Duration] into human-readable "2d 5h 30m" or "2d 5h 30m 15s".
  static String durationFormatter(
    Duration duration, {
    bool showSeconds = false,
  }) {
    final buffer = StringBuffer();

    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (days > 0) buffer.write("${days}d ");
    if (hours > 0) buffer.write("${hours}h ");
    buffer.write("${minutes}m");
    if (showSeconds) buffer.write(" ${seconds}s");

    return buffer.toString();
  }

  // ──────────────────────────────────────────
  // Numbers
  // ──────────────────────────────────────────

  /// Formats a number with commas: 1234567 → "1,234,567".
  static String numberWithCommas(num value) {
    final parts = value.toString().split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return parts.length > 1 ? "$intPart.${parts[1]}" : intPart;
  }

  /// Compact number: 1200 → "1.2K", 1500000 → "1.5M".
  static String compactNumber(num value) {
    if (value.abs() >= 1000000000) {
      return "${(value / 1000000000).toStringAsFixed(1)}B";
    } else if (value.abs() >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    } else if (value.abs() >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}K";
    }
    return value.toString();
  }

  /// Formats a double as currency: 1234.5 → "$1,234.50".
  static String currency(double value, {String symbol = "\$"}) {
    final formatted = numberWithCommas(double.parse(value.toStringAsFixed(2)));
    return "$symbol$formatted";
  }

  /// Formats a double as percentage: 0.756 → "75.6%".
  static String percentage(double value, {int decimals = 1}) {
    return "${(value * 100).toStringAsFixed(decimals)}%";
  }

  // ──────────────────────────────────────────
  // Strings
  // ──────────────────────────────────────────

  /// Converts "hello world" → "Hello World".
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Truncates text with ellipsis: "Hello World" → "Hello W...".
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return "${text.substring(0, maxLength)}...";
  }

  /// Masks text for privacy: "john@email.com" → "jo***@email.com".
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final masked = name.length > 2
        ? "${name.substring(0, 2)}${"*" * (name.length - 2)}"
        : name;
    return "$masked@${parts[1]}";
  }

  /// Masks phone: "+8801712345678" → "+880171****678".
  static String maskPhone(String phone) {
    if (phone.length < 7) return phone;
    final start = phone.substring(0, phone.length - 7);
    final middle = "****";
    final end = phone.substring(phone.length - 3);
    return "$start$middle$end";
  }

  // ──────────────────────────────────────────
  // File size
  // ──────────────────────────────────────────

  /// Formats bytes into human-readable: 1536 → "1.5 KB".
  static String fileSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1048576) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    if (bytes < 1073741824) return "${(bytes / 1048576).toStringAsFixed(1)} MB";
    return "${(bytes / 1073741824).toStringAsFixed(1)} GB";
  }

  // ──────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────

  static const _months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December",
  ];

  static const _monthsShort = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ];

  /// Returns full month name (1-indexed): 1 → "January".
  static String monthName(int month) {
    if (month < 1 || month > 12) return "Invalid Month";
    return _months[month - 1];
  }

  /// Returns short month name (1-indexed): 1 → "Jan".
  static String monthNameShort(int month) {
    if (month < 1 || month > 12) return "Invalid";
    return _monthsShort[month - 1];
  }
}
