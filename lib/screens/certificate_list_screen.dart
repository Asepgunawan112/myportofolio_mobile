import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/certificate.dart';
import 'package:myportofolio_mobile/screens/certificate_detail_screen.dart';
import 'package:myportofolio_mobile/screens/certificate_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class CertificateListScreen extends StatefulWidget {
  const CertificateListScreen({super.key});

  @override
  State<CertificateListScreen> createState() => _CertificateListScreenState();
}

class _CertificateListScreenState extends State<CertificateListScreen> {
  late Future<List<Certificate>> _certificatesFuture;

  @override
  void initState() {
    super.initState();
    _certificatesFuture = context.read<ApiClient>().getCertificates();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getCertificates();
    setState(() => _certificatesFuture = future);
    await future;
  }

  Future<void> _addCertificate() async {
    if (!await ensureLoggedIn(context) || !mounted) return;
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const CertificateFormPage()),
    );
    if (!mounted || created != true) return;
    await _reload();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Certificate saved.')));
  }

  Widget _stateList(BuildContext context, Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: constraints.maxHeight,
            child: Center(child: child),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Certificates')),
      drawer: const LeftDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCertificate,
        tooltip: 'Add certificate',
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<List<Certificate>>(
          future: _certificatesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _stateList(context, const CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _stateList(
                context,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Failed to load certificates: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            final certificates = snapshot.data ?? const <Certificate>[];
            if (certificates.isEmpty) {
              return _stateList(context, const Text('No certificates found.'));
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: certificates.length,
              itemBuilder: (context, index) {
                final certificate = certificates[index];
                return Card(
                  child: ListTile(
                    leading: _CertificateThumbnail(url: certificate.thumbnail),
                    title: Text(certificate.title),
                    subtitle: Text(
                      '${certificate.organization}\n${certificate.date}',
                    ),
                    isThreeLine: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) =>
                            CertificateDetailScreen(certificate: certificate),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CertificateThumbnail extends StatelessWidget {
  const _CertificateThumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return const SizedBox(
        width: 56,
        height: 56,
        child: Icon(Icons.workspace_premium_outlined),
      );
    }
    return Image.network(
      url!,
      width: 56,
      height: 56,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const SizedBox(
        width: 56,
        height: 56,
        child: Icon(Icons.workspace_premium_outlined),
      ),
    );
  }
}
