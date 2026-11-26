import 'package:flutter/material.dart';
import 'package:label_flutter_plugin/label_flutter_plugin.dart';

void main() => runApp(const MaterialApp(home: LabelDemoPage()));

/// Enter the package ID, client ID and license key, validate them through the
/// plugin, then show the label returned by the Android Label SDK.
class LabelDemoPage extends StatefulWidget {
  const LabelDemoPage({super.key});

  @override
  State<LabelDemoPage> createState() => _LabelDemoPageState();
}

class _LabelDemoPageState extends State<LabelDemoPage> {
  final _packageId = TextEditingController();
  final _clientId = TextEditingController();
  final _licenseKey = TextEditingController();

  bool _loading = false;
  String? _label;
  String? _status;

  @override
  void dispose() {
    _packageId.dispose();
    _clientId.dispose();
    _licenseKey.dispose();
    super.dispose();
  }

  Future<void> _validateAndLoad() async {
    setState(() {
      _loading = true;
      _label = null;
      _status = null;
    });

    final license = await LabelFlutterPlugin.initialize(
      packageId: _packageId.text.trim(),
      clientId: _clientId.text.trim(),
      licenseKey: _licenseKey.text.trim(),
    );

    String? label;
    String status = license.toString();
    if (license.isValid) {
      try {
        label = await LabelFlutterPlugin.getLabel();
      } on LabelLicenseException catch (e) {
        status = e.toString();
      }
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
      _label = label;
      _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Label plugin example')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _packageId,
            decoration: const InputDecoration(labelText: 'Package ID'),
          ),
          TextField(
            controller: _clientId,
            decoration: const InputDecoration(labelText: 'Client ID'),
          ),
          TextField(
            controller: _licenseKey,
            decoration: const InputDecoration(labelText: 'License key'),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _loading ? null : _validateAndLoad,
            child: _loading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Validate and get label'),
          ),
          const SizedBox(height: 24),
          if (_label != null)
            Text(_label!, style: Theme.of(context).textTheme.headlineSmall),
          if (_status != null) ...[
            const SizedBox(height: 8),
            Text(_status!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
