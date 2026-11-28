import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/certificate.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class CertificateFormPage extends StatefulWidget {
  const CertificateFormPage({super.key});

  @override
  State<CertificateFormPage> createState() => _CertificateFormPageState();
}

class _CertificateFormPageState extends State<CertificateFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _organization = '';
  String _thumbnail = '';
  DateTime? _date;
  bool _isSubmitting = false;

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (selected != null && mounted) setState(() => _date = selected);
  }

  String _dateString(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (!await ensureLoggedIn(context) || !mounted) return;
    if (!_formKey.currentState!.validate()) return;
    final token = context.read<AuthState>().token;
    if (token == null) return;

    setState(() => _isSubmitting = true);
    final certificate = Certificate(
      title: _title.trim(),
      organization: _organization.trim(),
      date: _dateString(_date!),
      thumbnail: _thumbnail.trim().isEmpty ? null : _thumbnail.trim(),
    );
    try {
      await context.read<ApiClient>().createCertificate(
        certificate,
        token: token,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Certificate saved successfully.')),
        );
      Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        await context.read<AuthState>().logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Session expired. Please log in.')),
          );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save certificate '
              '(${error.statusCode}): ${error.message}',
            ),
          ),
        );
      }
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error saving certificate: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Certificate')),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              maxLength: 255,
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) => _title = value,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Title is required.'
                  : null,
            ),
            TextFormField(
              maxLength: 255,
              decoration: const InputDecoration(labelText: 'Organization'),
              onChanged: (value) => _organization = value,
            ),
            const SizedBox(height: 8),
            FormField<DateTime>(
              initialValue: _date,
              validator: (value) => value == null ? 'Date is required.' : null,
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      await _selectDate();
                      field.didChange(_date);
                    },
                    child: Text(
                      _date == null
                          ? 'Select date (required)'
                          : _dateString(_date!),
                    ),
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 4),
                      child: Text(
                        field.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(labelText: 'Thumbnail URL'),
              onChanged: (value) => _thumbnail = value,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
