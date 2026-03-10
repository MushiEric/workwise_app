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
import '../../../../core/widgets/app_textfield.dart';
import 'package:workwise_erp/core/extensions/l10n_extension.dart';

typedef DioFactory = Dio Function(String baseUrl);

class WorkspaceEntryScreen extends ConsumerStatefulWidget {
  const WorkspaceEntryScreen({super.key, this.dioFactory});
  final DioFactory? dioFactory;

  @override
  ConsumerState<WorkspaceEntryScreen> createState() =>
      _WorkspaceEntryScreenState();
}

class _WorkspaceEntryScreenState extends ConsumerState<WorkspaceEntryScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _subdomainCtrl = TextEditingController();
  final FocusNode _subdomainFocus = FocusNode();
  bool _loading = false;

  late final AnimationController _pulseController;
  late final AnimationController _iconController;
  late final Animation<double> _iconAnimation;

  static const _baseDomain = 'workwise.africa';
  static const _domainSuffix = '.$_baseDomain';
  static final _validSubdomain = RegExp(r'^[a-z0-9]([a-z0-9\-]*[a-z0-9])?$');
  // match IPv4 with optional port
  static final _ipPattern = RegExp(r'^(?:\d{1,3}\.){3}\d{1,3}(?::\d+)?$');

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _iconAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.easeInOutSine,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _iconController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _iconController.forward();
        }
      });
    
    _iconController.forward();

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
    _pulseController.dispose();
    _iconController.dispose();
    _subdomainCtrl.dispose();
    _subdomainFocus.dispose();
    super.dispose();
  }

  String _buildApiBase(String input) {
    // if input looks like IP (with optional port) use it directly
    if (_ipPattern.hasMatch(input)) {
      // default to http for local testing
      final scheme = input.contains(':') ? 'http' : 'http';
      return '$scheme://$input/api';
    }
    return 'https://$input$_domainSuffix/api';
  }

  Future<void> _validateAndSave() async {
    final validation = _subdomainValidation(_subdomainCtrl.text);
    if (validation != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildErrorSnackBar(validation),
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
      // navigate directly to login/dashboard after saving
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _buildErrorSnackBar(
            'Could not connect to workspace. Please check and try again.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  SnackBar _buildErrorSnackBar(String message) {
    return SnackBar(
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.alertCircle,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
    );
  }


  String? _subdomainValidation(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Workspace subdomain or IP is required';
    }
    final s = v.trim();
    if (_ipPattern.hasMatch(s)) {
      return null; // valid IP
    }
    // when not IP ensure it is a proper subdomain
    if (s.contains('.')) {
      return 'Enter only the subdomain (no dots) or a raw IP';
    }
    if (!_validSubdomain.hasMatch(s)) {
      return 'Use letters, numbers, or hyphens only';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E21) : AppColors.surfaceVariantLight,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 480,
                  minHeight: MediaQuery.of(context).size.height - 120,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _BrandingHeader(
                      pulseController: _pulseController,
                      iconAnimation: _iconAnimation,
                    ),
                    const SizedBox(height: 40),
                    _buildAnimatedCard(context),
                    const SizedBox(height: 32),
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

  Widget _buildAnimatedCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.9, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.surface,
                  isDark ? cs.surface.withOpacity(0.8) : cs.surface,
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withOpacity(0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                  spreadRadius: -10,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: _subdomainFocus.hasFocus
                ? cs.primary.withOpacity(0.3)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSubdomainField(context),
              const SizedBox(height: 32),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubdomainField(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with animated indicator
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(
                        0.4 + (_pulseController.value * 0.3),
                      ),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              Text(
                'Workspace URL',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Animated input container
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _subdomainFocus.hasFocus
                  ? cs.primary
                  : cs.outline.withOpacity(0.2),
              width: _subdomainFocus.hasFocus ? 2 : 1,
            ),
            boxShadow: [
              if (_subdomainFocus.hasFocus)
                BoxShadow(
                  color: cs.primary.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              // Animated icon
              AnimatedBuilder(
                animation: _iconAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _subdomainFocus.hasFocus 
                        ? _iconAnimation.value 
                        : 1.0,
                    child: Icon(
                      _subdomainFocus.hasFocus
                          ? LucideIcons.penTool
                          : LucideIcons.globe,
                      size: 20,
                      color: _subdomainFocus.hasFocus
                          ? cs.primary
                          : cs.onSurfaceVariant,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
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
                  hintText: 'subdomain or IP (e.g. 10.26.154.239)',
                ),
              ),
              // Domain suffix with gradient (hide when IP entered)
              if (!_ipPattern.hasMatch(_subdomainCtrl.text))
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        cs.primary.withOpacity(0.1),
                        cs.primary.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(22),
                    ),
                  ),
                  child: Text(
                    _domainSuffix,
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),            ],
          ),
        ),

        // Helper text with animation
        AnimatedOpacity(
          opacity: _subdomainFocus.hasFocus ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.only(left: 4, top: 8),
            child: Row(
              children: [
                Icon(
                  LucideIcons.info,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 6),
                Text(
                  'Use letters, numbers, and hyphens only',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.95, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuad,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _loading ? null : _validateAndSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: _loading
                    ? const SizedBox(
                        key: ValueKey(1),
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        key: const ValueKey(2),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.rocket,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Launch Workspace',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            LucideIcons.arrowRight,
                            size: 20,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        // Animated decorative elements
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 800 + (index * 200)),
              curve: Curves.elasticOut,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 16),
        // Main footer text
        Text(
          context.l10n.termsAgreement,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.muted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        // Additional trust indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.shield,
              size: 14,
              color: Colors.green.shade400,
            ),
            const SizedBox(width: 6),
            Text(
              'Enterprise-grade security',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.green.shade600,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            ),
            Icon(
              LucideIcons.lock,
              size: 14,
              color: Colors.blue.shade400,
            ),
            const SizedBox(width: 6),
            Text(
              'SSL encrypted',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.blue.shade600,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BrandingHeader extends StatelessWidget {
  final AnimationController pulseController;
  final Animation<double> iconAnimation;

  const _BrandingHeader({
    required this.pulseController,
    required this.iconAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Column(
            children: [
              // Logo with animated glow
              AnimatedBuilder(
                animation: pulseController,
                builder: (context, child) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(
                            0.2 + (pulseController.value * 0.2),
                          ),
                          blurRadius: 30 + (pulseController.value * 20),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // App name with icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: iconAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: iconAnimation.value * 0.1,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.sparkles,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppConstant.appName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Subtitle with decorative elements
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.primary.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Sign in to your workspace',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 20,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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