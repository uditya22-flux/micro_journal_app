// lib/providers/journal_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/entry_model.dart';
import '../services/storage_service.dart';

class JournalProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  Map<String, JournalEntry> _entries = {};
  bool _isLoading = true;
  bool _isSaving = false;

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  /// All entries sorted newest first (for the History screen).
  List<JournalEntry> get sortedEntries {
    final list = _entries.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// The canonical date key for today.
  String get todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// Whether today's entry already exists.
  bool get hasTodayEntry => _entries.containsKey(todayKey);

  /// The entry for today, or null if not yet written.
  JournalEntry? get todayEntry => _entries[todayKey];

  /// Expose entries map for analytics
  Map<String, JournalEntry> get entries => _entries;

  /// Get entry for a specific date, or null if not found.
  JournalEntry? getEntryForDate(String dateKey) => _entries[dateKey];

  /// Initialise by loading persisted entries from storage.
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _entries = await _storage.loadEntries();

    _isLoading = false;
    notifyListeners();
  }

  /// Save a new entry for today. Returns false if today already has one.
  Future<bool> saveTodayEntry(String content) async {
    if (hasTodayEntry) return false;

    final trimmed = content.trim();
    if (trimmed.isEmpty) return false;

    _isSaving = true;
    notifyListeners();

    final entry = JournalEntry(
      date: todayKey,
      content: trimmed,
      createdAt: DateTime.now(),
    );

    _entries[todayKey] = entry;
    await _storage.saveEntries(_entries);

    // Premium haptic feedback on save
    await HapticFeedback.mediumImpact();

    _isSaving = false;
    notifyListeners();
    return true;
  }

  /// Edit an existing entry. Returns false if no entry exists for that date.
  Future<bool> editEntry(String date, String content) async {
    if (!_entries.containsKey(date)) return false;

    final trimmed = content.trim();
    if (trimmed.isEmpty) return false;

    _entries[date] = _entries[date]!.copyWith(content: trimmed);
    await _storage.saveEntries(_entries);

    await HapticFeedback.lightImpact();
    notifyListeners();
    return true;
  }
}
