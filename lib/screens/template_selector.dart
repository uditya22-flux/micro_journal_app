import 'package:flutter/material.dart';
import 'web_template_view.dart';

class TemplateSelector extends StatelessWidget {
  const TemplateSelector({Key? key}) : super(key: key);

  final List<Map<String, String>> templates = const [
    {"name": "Autumn Warmth", "asset": "assets/web_templates/autumn.html"},
    {"name": "Winter Calm", "asset": "assets/web_templates/winter.html"},
    {"name": "Summer Vitality", "asset": "assets/web_templates/summer.html"},
    {"name": "Rainy Reflection", "asset": "assets/web_templates/rain.html"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Template')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final t = templates[index];
          return ListTile(
            title: Text(t['name']!),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => WebTemplateView(assetPath: t['asset']!),
              ));
            },
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: templates.length,
      ),
    );
  }
}
