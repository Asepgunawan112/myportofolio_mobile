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
          _DetailItem(label: 'Description', value: experience.description),
          _DetailItem(label: 'Category', value: experience.category ?? ''),
          _DetailItem(label: 'Tech stack', value: experience.techStack),
          _DetailItem(label: 'Project URL', value: experience.projectUrl),
          _DetailItem(
            label: 'Experience link',
            value: experience.experienceLink ?? '',
          ),
          if (experience.projectImageUrl.isNotEmpty)
            _DetailItem(
              label: 'Project image URL',
              value: experience.projectImageUrl,
            ),
        ],
      ),
    );
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
