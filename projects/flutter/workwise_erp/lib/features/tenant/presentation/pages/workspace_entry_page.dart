import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/environment.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../core/models/tenant.dart';
import '../../../../core/provider/tenant_provider.dart';
import '../../../../core/storage/tenant_local_data_source.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/extensions/l10n_extension.dart';

typedef DioFactory = Dio Function(String baseUrl);

class WorkspaceEntryScreen extends ConsumerStatefulWidget {
  /// [dioFactory] is optional and used for testing — it receives the normalized
  /// API base and should return a configured Dio instance.
  const WorkspaceEntryScreen({super.key, this.dioFactory});

  final DioFactory? dioFactory;

  @override
  ConsumerState<WorkspaceEntryScreen> createState() => _WorkspaceEntryScreenState();
}

class _WorkspaceEntryScreenState extends ConsumerState<WorkspaceEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subdomainCtrl = TextEditingController();
  final FocusNode _subdomainFocus = FocusNode();
  bool _loading = false;
  String? _error;

  static const _baseDomain = 'workwise.africa';
  static const _domainSuffix = '.$_baseDomain';

  /// Valid subdomain: starts/ends with alphanumeric, middle may include hyphens.
  static final _validSubdomain = RegExp(r'^[a-z0-9]([a-z0-9\-]*[a-z0-9])?$');

  @override
  void initState() {
    super.initState();
    // In dev, prefill the subdomain from EnvConfig for convenience.
    if (EnvConfig.current.env == AppEnvironment.dev) {
      try {
        final host = Uri.parse(EnvConfig.current.baseUrl).host;
        if (host.endsWith(_domainSuffix)) {
          final subdomain = host.substring(0, host.length - _domainSuffix.length);
          // Only prefill if it's a single-level subdomain (no dots)
          if (!subdomain.contains('.')) {
            _subdomainCtrl.text = subdomain;
          }
        }
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _subdomainCtrl.dispose();
    _subdomainFocus.dispose();
    super.dispose();
  }

  /// Builds the API base URL from a validated single-level subdomain.
  String _buildApiBase(String subdomain) => 'https://$subdomain$_domainSuffix/api';

  Future<void> _validateAndSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final subdomain = _subdomainCtrl.text.trim().toLowerCase();
    final apiBase = _buildApiBase(subdomain);

    try {
      await ref.read(tenantLocalDataSourceProvider).saveTenant(apiBase);
      ref.read(tenantProvider.notifier).state = Tenant(apiBase);
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
    } catch (e) {
      setState(() => _error = context.l10n.couldNotConnect);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceVariantLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BrandingHeader(),
                  const SizedBox(height: 32),
                  _buildCard(context),
                  const SizedBox(height: 24),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outline.withOpacity(0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.enterYourWorkspace,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.subdomainDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.muted,
                    ),
              ),
              const SizedBox(height: 20),
              _buildSubdomainField(context),
              if (_error != null) ...[
                const SizedBox(height: 12),
                _buildErrorBanner(context),
              ],
              const SizedBox(height: 20),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubdomainField(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _subdomainCtrl,
          focusNode: _subdomainFocus,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _validateAndSave(),
          enabled: !_loading,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
            _LowercaseInputFormatter(),
          ],
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.language_rounded),
            suffix: Text(
              _domainSuffix,
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            labelText: context.l10n.subdomain,
            hintText: context.l10n.subdomainHint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.outline.withOpacity(0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: cs.error),
            ),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return context.l10n.workspaceRequired;
            final s = v.trim().toLowerCase();
            if (s.contains('.')) return context.l10n.enterSubdomainOnly;
            if (!_validSubdomain.hasMatch(s)) {
              return context.l10n.useLettersNumbersHyphens;
            }
            return null;
          },
        ),
        const SizedBox(height: 6),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _subdomainCtrl,
          builder: (_, val, __) {
            final sub = val.text.trim().isEmpty ? 'yourcompany' : val.text.trim();
            return Text(
              'https://$sub$_domainSuffix',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.muted, fontFamily: 'monospace'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildErrorBanner(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 16, color: cs.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(color: cs.error, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _loading ? null : _validateAndSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: _loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.l10n.continueButton, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Text(
      context.l10n.termsAgreement,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
    );
  }
}

class _BrandingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            // color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.hardEdge,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppConstant.appName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.signInToWorkspace,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}

/// Forces all input to lowercase as the user types.
class _LowercaseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) =>
      newValue.copyWith(text: newValue.text.toLowerCase());
}
