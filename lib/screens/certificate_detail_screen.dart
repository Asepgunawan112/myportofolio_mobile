import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/certificate.dart';

class CertificateDetailScreen extends StatelessWidget {
  const CertificateDetailScreen({super.key, required this.certificate});

  final Certificate certificate;

  @override
  Widget build(BuildContext context) {
    final thumbnail = certificate.thumbnail;
    return Scaffold(
      appBar: AppBar(title: Text(certificate.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (thumbnail != null && thumbnail.isNotEmpty)
            Image.network(
              thumbnail,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const _CertificateImageFallback(),
            )
          else
            const _CertificateImageFallback(),
          const SizedBox(height: 16),
          Text(
            certificate.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (certificate.organization.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(certificate.organization),
          ],
          const SizedBox(height: 8),
          Text(certificate.date),
          if (certificate.id != null) ...[
            const SizedBox(height: 8),
            Text('ID: ${certificate.id}'),
          ],
        ],
      ),
    );
  }
}

class _CertificateImageFallback extends StatelessWidget {
  const _CertificateImageFallback();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 120,
    child: Center(child: Icon(Icons.workspace_premium_outlined, size: 48)),
  );
}
