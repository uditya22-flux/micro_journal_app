import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../models/entry_model.dart';
import '../providers/journal_provider.dart';
import '../providers/journal_analytics.dart';
import '../services/theme_service.dart';
import 'histor_screen.dart';
import 'writing_screen.dart';
import 'template_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  int _selectedDayOffset = 0; // 0 = today, 1 = yesterday, etc.

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _formatDateOffset(int offset) {
    final date = DateTime.now().subtract(Duration(days: offset));
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = context.watch<ThemeService>();
    final provider = context.watch<JournalProvider>();

    if (provider.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    final todayKey = _formatDateOffset(_selectedDayOffset);
    final entry = provider.getEntryForDate(todayKey);
    final now = DateTime.now();
    final streak = provider.entries.calculateStreak();
    final monthlyCount = provider.entries.getMonthlyCount();

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('micro journal'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'templates') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const TemplateSelector(),
                ));
                return;
              }
              if (value == 'theme_autumn') {
                themeService.switchTheme(AppThemeMode.autumnWarmth);
              } else if (value == 'theme_rain') {
                themeService.switchTheme(AppThemeMode.rainyReflection);
              } else if (value == 'theme_winter') {
                themeService.switchTheme(AppThemeMode.winterCalm);
              } else if (value == 'theme_summer') {
                themeService.switchTheme(AppThemeMode.summerVitality);
              } else if (value == 'history') {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, animation, __) => const HistoryScreen(),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                    transitionDuration: const Duration(milliseconds: 350),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'theme_autumn',
                child: Text('Autumn Warmth'),
              ),
              const PopupMenuItem(
                value: 'theme_rain',
                child: Text('Rainy Reflection'),
              ),
              const PopupMenuItem(
                value: 'theme_winter',
                child: Text('Winter Calm'),
              ),
              const PopupMenuItem(
                value: 'theme_summer',
                child: Text('Summer Vitality'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'history',
                child: Text('📚 History'),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          _SeasonBackground(flavor: themeService.flavor),
          FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 104),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  _GlassPanel(
                    frosted: themeService.flavor.frosted,
                    child: _CalendarStrip(
                      selectedOffset: _selectedDayOffset,
                      onDaySelected: (offset) {
                        setState(() => _selectedDayOffset = offset);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          themeService.flavor.label.toUpperCase(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            letterSpacing: 2.5,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM d, yyyy').format(
                            DateTime.now().subtract(Duration(days: _selectedDayOffset)),
                          ),
                          style: theme.textTheme.displaySmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          themeService.flavor.subtitle,
                          style: theme.textTheme.bodySmall,
                        ),

                        const SizedBox(height: 24),

                        _GlassPanel(
                          frosted: themeService.flavor.frosted,
                          child: _CheckInCard(
                            hour: now.hour,
                            theme: theme,
                          ),
                        ),

                        const SizedBox(height: 20),

                        _GlassPanel(
                          frosted: themeService.flavor.frosted,
                          child: _ConsistencyBar(
                            streak: streak,
                            monthlyCount: monthlyCount,
                            theme: theme,
                          ),
                        ),

                        const SizedBox(height: 20),

                        if (entry != null)
                          _GlassPanel(
                            frosted: themeService.flavor.frosted,
                            child: _SavedEntryView(
                              entry: entry,
                              todayKey: todayKey,
                              onEdit: (content) async {
                                await provider.editEntry(todayKey, content);
                              },
                            ),
                          )
                        else if (_selectedDayOffset == 0)
                          _GlassPanel(
                            frosted: themeService.flavor.frosted,
                            child: _EntryPrompt(theme: theme),
                          ),

                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _SeasonBottomBar(
        onTimelineTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, animation, __) => const HistoryScreen(),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
      ),
      floatingActionButton: _selectedDayOffset == 0
          ? OpenContainer(
              transitionType: ContainerTransitionType.fade,
              openBuilder: (context, action) => WritingScreen(
                onSave: (content) async {
                  await provider.saveTodayEntry(content);
                  Navigator.of(context).pop();
                },
              ),
              closedBuilder: (context, action) => FloatingActionButton(
                onPressed: action,
                child: const Icon(Icons.edit_outlined),
              ),
            )
          : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendar Strip Component
// ─────────────────────────────────────────────────────────────────────────────

class _CalendarStrip extends StatelessWidget {
  final int selectedOffset;
  final void Function(int) onDaySelected;

  const _CalendarStrip({
    required this.selectedOffset,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 30,
        itemBuilder: (context, index) {
          final date = DateTime.now().subtract(Duration(days: index));
          final isSelected = index == selectedOffset;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => onDaySelected(index),
              child: _DayBubble(
                date: date,
                isSelected: isSelected,
                theme: theme,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DayBubble extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final ThemeData theme;

  const _DayBubble({
    required this.date,
    required this.isSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = DateTime.now().day == date.day &&
        DateTime.now().month == date.month &&
        DateTime.now().year == date.year;

    return Container(
      width: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
        border: Border.all(
          color: isToday ? theme.colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('E').format(date),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Check-In Card Component
// ─────────────────────────────────────────────────────────────────────────────

class _CheckInCard extends StatelessWidget {
  final int hour;
  final ThemeData theme;

  const _CheckInCard({required this.hour, required this.theme});

  String _getTimeOfDayGreeting() {
    if (hour < 12) return '☀️ Good Morning';
    if (hour < 18) return '🌤️ Good Afternoon';
    return '🌙 Good Evening';
  }

  Color _getTimeOfDayColor() {
    if (hour < 12) return const Color(0xFFFFB74D); // Morning gold
    if (hour < 18) return const Color(0xFF81C784); // Afternoon green
    return const Color(0xFF5C6BC0); // Evening indigo
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getTimeOfDayColor().withOpacity(0.15),
            _getTimeOfDayColor().withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _getTimeOfDayColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getTimeOfDayGreeting(),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: _getTimeOfDayColor(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'What\'s on your mind today?',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Consistency Bar Component
// ─────────────────────────────────────────────────────────────────────────────

class _ConsistencyBar extends StatelessWidget {
  final int streak;
  final int monthlyCount;
  final ThemeData theme;

  const _ConsistencyBar({
    required this.streak,
    required this.monthlyCount,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✨ Your Streak',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '$streak day${streak != 1 ? 's' : ''}',
              style: theme.textTheme.displaySmall?.copyWith(
                fontSize: 28,
                color: theme.colorScheme.primary,
              ),
            ),
            const Spacer(),
            Text(
              '$monthlyCount entries this month',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (streak % 30) / 30,
            minHeight: 8,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Entry View Component
// ─────────────────────────────────────────────────────────────────────────────

class _SavedEntryView extends StatefulWidget {
  final JournalEntry entry;
  final String todayKey;
  final Future<void> Function(String) onEdit;

  const _SavedEntryView({
    required this.entry,
    required this.todayKey,
    required this.onEdit,
  });

  @override
  State<_SavedEntryView> createState() => _SavedEntryViewState();
}

class _SeasonBackground extends StatelessWidget {
  final ThemeFlavor flavor;

  const _SeasonBackground({required this.flavor});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [flavor.backgroundTop, flavor.backgroundBottom],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -120,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: flavor.orbA,
              ),
            ),
          ),
          Positioned(
            left: -110,
            bottom: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: flavor.orbB,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final bool frosted;
  final Widget child;

  const _GlassPanel({required this.frosted, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: frosted ? 16 : 0, sigmaY: frosted ? 16 : 0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: frosted ? 0.28 : 0.95),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SeasonBottomBar extends StatelessWidget {
  final VoidCallback onTimelineTap;

  const _SeasonBottomBar({required this.onTimelineTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavPill(icon: Icons.edit_note_rounded, label: 'Capture', active: true, onTap: () {}),
                  _NavPill(icon: Icons.history_rounded, label: 'Timeline', active: false, onTap: onTimelineTap),
                  _NavPill(icon: Icons.palette_outlined, label: 'Theme', active: false, onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavPill({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: active ? cs.primary.withValues(alpha: 0.16) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: active ? cs.primary : cs.onSurface.withValues(alpha: 0.7)),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
                letterSpacing: 0.8,
                color: active ? cs.primary : cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedEntryViewState extends State<_SavedEntryView> {
  bool _editing = false;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController =
        TextEditingController(text: widget.entry.content);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.colorScheme.secondary;

    if (_editing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _editController,
            autofocus: true,
            maxLines: 5,
            maxLength: 200,
            style: theme.textTheme.headlineSmall,
            decoration: InputDecoration(
              hintText: 'Edit your entry…',
              border: InputBorder.none,
              counterStyle: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await widget.onEdit(_editController.text);
                    setState(() => _editing = false);
                  },
                  child: const Text('Save Changes'),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  _editController.text = widget.entry.content;
                  setState(() => _editing = false);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: secondaryColor),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u201C',
          style: TextStyle(
            fontSize: 48,
            color: secondaryColor.withOpacity(0.3),
            height: 0.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(widget.entry.content, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => setState(() => _editing = true),
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 13, color: secondaryColor),
              const SizedBox(width: 6),
              Text(
                'Edit entry',
                style: theme.textTheme.bodySmall?.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Entry Prompt Component
// ─────────────────────────────────────────────────────────────────────────────

class _EntryPrompt extends StatelessWidget {
  final ThemeData theme;

  const _EntryPrompt({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'No entry yet today.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Tap the button below to start writing.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

