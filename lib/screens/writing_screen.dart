import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WritingScreen extends StatefulWidget {
  final Future<void> Function(String) onSave;

  const WritingScreen({required this.onSave, super.key});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write something first.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.onSave(text);
      HapticFeedback.mediumImpact();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final charCount = _controller.text.length;
    final maxChars = 200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('What happened today?'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                '$charCount / $maxChars',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── Progress Bar ─────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: charCount / maxChars,
              minHeight: 3,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),

          // ─── Text Input ───────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: TextField(
                controller: _controller,
                autofocus: true,
                maxLines: null,
                maxLength: maxChars,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: theme.textTheme.headlineSmall,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'One thought. One moment.',
                  hintStyle: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                  counterStyle: theme.textTheme.bodySmall,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),

          // ─── Save Button ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                child: _isSaving
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                      )
                    : const Text('Save Entry'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
