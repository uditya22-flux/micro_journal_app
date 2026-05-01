// lib/models/entry_model.dart

class JournalEntry {
  final String date; // YYYY-MM-DD (used as unique key)
  final String content;
  final DateTime createdAt;

  JournalEntry({
    required this.date,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        date: json['date'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  JournalEntry copyWith({String? content}) => JournalEntry(
        date: date,
        content: content ?? this.content,
        createdAt: createdAt,
      );
}
