import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';



/// Blocks the app with an update screen when this build is older than the
/// minimum set in `web/app_config.json` (served by the app's web site):
///
///   { "minBuild": { "android": 3, "ios": 3, "message": "optional" } }
///
/// Bump it and run `firebase deploy --only hosting`; no app release needed.
/// Web always serves the latest build, so it is never blocked. Any failure
/// (offline, missing node) lets the app run.
class ForceUpdateGate extends StatefulWidget {
  const ForceUpdateGate({super.key, required this.child});

  final Widget child;

  @override
  State<ForceUpdateGate> createState() => _ForceUpdateGateState();
}

class _ForceUpdateGateState extends State<ForceUpdateGate>
    with WidgetsBindingObserver {
  String? _message;
  bool _required = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Back from the store: check again.
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    if (kIsWeb) return;
    final platform = switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      _ => null,
    };
    if (platform == null) return;
    try {
      final info = await PackageInfo.fromPlatform();
      final build = int.tryParse(info.buildNumber) ?? 0;
      final resp = await http
          .get(Uri.parse('https://ahmed-elsayed-dawah.web.app/app_config.json'))
          .timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) return;
      final root = json.decode(resp.body);
      final data = root is Map ? root['minBuild'] : null;
      if (data is! Map) return;
      final min = (data[platform] as num?)?.toInt() ?? 0;
      final required = build > 0 && build < min;
      if (!mounted) return;
      setState(() {
        _required = required;
        _message = data['message'] as String?;
      });
    } catch (e) {
      log('ForceUpdateGate: $e');
    }
  }

  Future<void> _openStore() async {
    final info = await PackageInfo.fromPlatform();
    final uri = defaultTargetPlatform == TargetPlatform.iOS
        ? Uri.parse('https://apps.apple.com/search?term=ahmed%20elsayed')
        : Uri.parse('market://details?id=${info.packageName}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        defaultTargetPlatform == TargetPlatform.android) {
      await launchUrl(
        Uri.parse(
            'https://play.google.com/store/apps/details?id=${info.packageName}'),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_required) return widget.child;
    final scheme = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.system_update_rounded,
                        size: 72, color: scheme.primary),
                    const SizedBox(height: 20),
                    const Text(
                      'يوجد تحديث جديد',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _message ??
                          'حدّث تطبيق أحمد السيد لتحصل على أحدث الدروس والمزايا.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                           fontSize: 15, height: 1.6),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _openStore,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('تحديث الآن',
                            style: TextStyle(
                                
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
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
