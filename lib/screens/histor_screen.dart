// lib/screens/history_screen.dart

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/entry_model.dart';
import '../providers/journal_provider.dart';
import '../services/theme_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<JournalProvider>();
    final themeService = context.watch<ThemeService>();
    final entries = provider.sortedEntries;
    // Exclude today's entry from history (it's shown on Home)
    final todayKey = provider.todayKey;
    final historyEntries =
        entries.where((e) => e.date != todayKey).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('reflect'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Center(
              child: Text(
                '${historyEntries.length}',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
      body: historyEntries.isEmpty
          ? Stack(
              children: [
                _HistoryBackdrop(flavor: themeService.flavor),
                _buildEmptyState(theme),
              ],
            )
          : Stack(
              children: [
                _HistoryBackdrop(flavor: themeService.flavor),
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _animController,
                    curve: Curves.easeOut,
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 100, 24, 40),
                    itemCount: historyEntries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return _EntryTile(
                        entry: historyEntries[index],
                        index: index,
                        totalCount: historyEntries.length,
                        animController: _animController,
                        onEdit: (date, content) async {
                          await provider.editEntry(date, content);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 36,
              color: theme.colorScheme.secondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 20),
            Text(
              'Your story starts today.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Past entries will appear here.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Entry Tile ────────────────────────────────────────────────────────────────

class _EntryTile extends StatefulWidget {
  final JournalEntry entry;
  final int index;
  final int totalCount;
  final AnimationController animController;
  final Future<void> Function(String date, String content) onEdit;

  const _EntryTile({
    required this.entry,
    required this.index,
    required this.totalCount,
    required this.animController,
    required this.onEdit,
  });

  @override
  State<_EntryTile> createState() => _EntryTileState();
}

class _EntryTileState extends State<_EntryTile> {
  bool _expanded = false;
  bool _editing = false;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.entry.content);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  String _formatDate(String dateKey) {
    final date = DateTime.parse(dateKey);
    return DateFormat('MMM d').format(date);
  }

  String _formatYear(String dateKey) {
    final date = DateTime.parse(dateKey);
    return DateFormat('yyyy').format(date);
  }

  String _formatDayOfWeek(String dateKey) {
    final date = DateTime.parse(dateKey);
    return DateFormat('EEE').format(date).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.secondary;

    // Staggered slide + fade per item
    final delay = (widget.index / widget.totalCount.clamp(1, 10)) * 0.6;
    final itemAnim = CurvedAnimation(
      parent: widget.animController,
      curve: Interval(delay, (delay + 0.4).clamp(0, 1), curve: Curves.easeOut),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AnimatedBuilder(
          animation: itemAnim,
          builder: (context, child) => FadeTransition(
            opacity: itemAnim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(itemAnim),
              child: child,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Left: date column ─────────────────────────────────────
              SizedBox(
                width: 54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(widget.entry.date),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDayOfWeek(widget.entry.date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        letterSpacing: 1,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      _formatYear(widget.entry.date),
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),

              // ── Vertical separator ────────────────────────────────────
              Container(
                width: 1,
                height: _expanded ? null : 44,
                color: secondary.withValues(alpha: 0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),

              // ── Right: entry content ──────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_editing) ...[
                      TextField(
                        controller: _editController,
                        autofocus: true,
                        maxLines: 3,
                        maxLength: 200,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterStyle: theme.textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await widget.onEdit(
                                widget.entry.date,
                                _editController.text,
                              );
                              setState(() => _editing = false);
                            },
                            child: Text(
                              'Save',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              _editController.text = widget.entry.content;
                              setState(() => _editing = false);
                            },
                            child: Text(
                              'Cancel',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        widget.entry.content,
                        style: theme.textTheme.bodyLarge,
                        maxLines: _expanded ? null : 2,
                        overflow: _expanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                      if (_expanded) ...[
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => setState(() => _editing = true),
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined,
                                  size: 11, color: secondary),
                              const SizedBox(width: 4),
                              Text(
                                'Edit',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryBackdrop extends StatelessWidget {
  final ThemeFlavor flavor;

  const _HistoryBackdrop({required this.flavor});

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
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(shape: BoxShape.circle, color: flavor.orbA),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -100,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(shape: BoxShape.circle, color: flavor.orbB),
            ),
          ),
        ],
      ),
    );
  }
}
