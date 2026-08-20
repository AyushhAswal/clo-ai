extension StringNameFormatter on String {
  /// Formats a full name string to Title Case while preserving all spaces.
  ///
  /// Examples:
  /// - `"ayush aswal"` -> `"Ayush Aswal"`
  /// - `"AYUSH ASWAL"` -> `"Ayush Aswal"`
  /// - `"ayush"` -> `"Ayush"`
  /// - `"  john   doe  "` -> `"John Doe"`
  String toTitleCase() {
    final trimmed = trim();
    if (trimmed.isEmpty) return '';

    return trimmed
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
