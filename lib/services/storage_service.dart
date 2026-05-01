import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/entry_model.dart';

class StorageService {
  static const String _entriesKey = 'micro_journal_entries';

  Future<Map<String, JournalEntry>> loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = prefs.getString(_entriesKey);
      if (rawJson == null || rawJson.isEmpty) return {};

      final Map<String, dynamic> decoded =
          jsonDecode(rawJson) as Map<String, dynamic>;

      return decoded.map(
        (key, value) => MapEntry(
          key,
          JournalEntry.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      return {};
    }
  }

  Future<bool> saveEntries(Map<String, JournalEntry> entries) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(
        entries.map((key, entry) => MapEntry(key, entry.toJson())),
      );
      return prefs.setString(_entriesKey, encoded);
    } catch (_) {
      return false;
    }
  }
}