import 'package:intl/intl.dart';
import '../models/entry_model.dart';

extension JournalAnalytics on Map<String, JournalEntry> {
  /// Calculate current journaling streak
  int calculateStreak() {
    if (isEmpty) return 0;

    final sortedDates = keys.map((d) => DateTime.parse(d)).toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime currentDate = DateTime.now();

    for (final date in sortedDates) {
      // Normalize to date only
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final normalizedCurrent = DateTime(currentDate.year, currentDate.month, currentDate.day);

      if (normalizedCurrent.difference(normalizedDate).inDays == streak) {
        streak++;
        currentDate = normalizedDate;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Get last 7 days of entry counts
  List<int> getLast7DaysActivity() {
    final result = <int>[];
    DateTime now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      result.add(containsKey(dateKey) ? 1 : 0);
    }

    return result;
  }

  /// Get day of week for a date key
  String getDayOfWeek(String dateKey) {
    final date = DateTime.parse(dateKey);
    return DateFormat('E').format(date);
  }

  /// Get total entries this month
  int getMonthlyCount() {
    final now = DateTime.now();
    return keys.where((dateKey) {
      final date = DateTime.parse(dateKey);
      return date.year == now.year && date.month == now.month;
    }).length;
  }
}
