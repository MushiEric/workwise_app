import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/config/environment.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../core/models/tenant.dart';
import '../../../../core/provider/tenant_provider.dart';
// import '../../../../core/storage/tenant_local_data_source.dart';
import '../../../../core/themes/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_textfiled.dart';
import 'package:workwise_erp/core/extensions/l10n_extension.dart';
typedef DioFactory = Dio Function(String baseUrl);

class WorkspaceEntryScreen extends ConsumerStatefulWidget {
  const WorkspaceEntryScreen({super.key, this.dioFactory});
  final DioFactory? dioFactory;

  @override
  ConsumerState<WorkspaceEntryScreen> createState() =>
      _WorkspaceEntryScreenState();
}

class _WorkspaceEntryScreenState extends ConsumerState<WorkspaceEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subdomainCtrl = TextEditingController();
  final FocusNode _subdomainFocus = FocusNode();
  bool _loading = false;

  static const _baseDomain = 'workwise.africa';
  static const _domainSuffix = '.$_baseDomain';
  static final _validSubdomain = RegExp(r'^[a-z0-9]([a-z0-9\-]*[a-z0-9])?$');

  @override
  void initState() {
    super.initState();
    if (EnvConfig.current.env == AppEnvironment.dev) {
      try {
        final host = Uri.parse(EnvConfig.current.baseUrl).host;
        if (host.endsWith(_domainSuffix)) {
          final sub = host.substring(0, host.length - _domainSuffix.length);
          if (!sub.contains('.')) _subdomainCtrl.text = sub;
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

  String _buildApiBase(String subdomain) =>
      'https://$subdomain$_domainSuffix/api';

  Future<void> _validateAndSave() async {
    final validation = _subdomainValidation(_subdomainCtrl.text);
    if (validation != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validation),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    setState(() {
      _loading = true;
    });

    try {
      final sub = _subdomainCtrl.text.trim().toLowerCase();
      final apiBase = _buildApiBase(sub);

      await ref.read(tenantLocalDataSourceProvider).saveTenant(apiBase);
      ref.read(tenantProvider.notifier).state = Tenant(apiBase);

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Could not connect to workspace. Please check and try again.',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _subdomainValidation(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Workspace subdomain is required';
    }
    final s = v.trim();
    if (s.contains('.')) {
      return 'Enter only the subdomain';
    }
    if (!_validSubdomain.hasMatch(s)) {
      return 'Use letters, numbers, or hyphens only';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - value)),
            child: Transform.scale(scale: 0.96 + (0.04 * value), child: child),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceVariantLight,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
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
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSubdomainField(context),
            const SizedBox(height: 24),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubdomainField(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _subdomainFocus.hasFocus
                  ? cs.primary
                  : cs.outline.withOpacity(0.4),
              width: _subdomainFocus.hasFocus ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(LucideIcons.globe, size: 20, color: cs.onSurfaceVariant),
              Expanded(
                child: AppTextField(
                  controller: _subdomainCtrl,
                  focusNode: _subdomainFocus,
                  autofocus: true,
                  enabled: !_loading,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _validateAndSave(),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    _LowercaseInputFormatter(),
                  ],
                  validator: (_) => null,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 44,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withOpacity(0.6),
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(14),
                  ),
                ),
                child: Text(
                  _domainSuffix,
                  style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _loading ? null : _validateAndSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _loading
              ? const SizedBox(
                  key: ValueKey(1),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  key: ValueKey(2),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(LucideIcons.arrowRight,
                    color: AppColors.white,
                     size: 18),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Text(
      context.l10n.termsAgreement,
      textAlign: TextAlign.center,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
    );
  }
}

class _BrandingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.hardEdge,
          child: Image.asset('assets/images/logo.png'),
        ),
        SizedBox(height: 0.h),
        Text(
          AppConstant.appName,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontSize: 22.sp),
        ),
        SizedBox(height: 6.h),
        Text(
          'Sign in to your workspace',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}

class _LowercaseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toLowerCase());
}
