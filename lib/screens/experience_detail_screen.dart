import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({super.key, required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(experience.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (experience.thumbnail != null && experience.thumbnail!.isNotEmpty)
            Image.network(
              experience.thumbnail!,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 120,
                child: Center(child: Icon(Icons.work_outline, size: 48)),
              ),
            )
          else
            const SizedBox(
              height: 120,
              child: Center(child: Icon(Icons.work_outline, size: 48)),
            ),
          _DetailItem(label: 'Description', value: experience.description),
          _DetailItem(label: 'Category', value: experience.category),
          _DetailItem(
            label: 'Started',
            value: _formatDate(experience.startedAt) ?? 'Not specified',
          ),
          _DetailItem(
            label: 'Ended',
            value: _formatDate(experience.endedAt) ?? 'Present',
          ),
        ],
      ),
    );
  }

  String? _formatDate(String? value) {
    if (value == null || value.isEmpty) return null;
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          SelectableText(value),
        ],
      ),
    );
  }
}
