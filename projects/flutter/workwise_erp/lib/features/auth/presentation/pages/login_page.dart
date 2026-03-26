import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// centralise icon tokens for easy re-themeing
import '../../../../core/themes/app_icons.dart';

import 'package:workwise_erp/core/widgets/app_textfield.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/core/provider/locale_provider.dart';
import 'package:workwise_erp/core/provider/navigator_key_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/extensions/l10n_extension.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Clear any leftover snackbars from earlier flows (e.g., forgot-password)
    ref.read(scaffoldMessengerKeyProvider).currentState?.clearSnackBars();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(authNotifierProvider.notifier);

    await notifier.login(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );

    // avoid using context if the widget was disposed while awaiting
    if (!mounted) return;

    final state = ref.read(authNotifierProvider);

    state.when(
      initial: () => null,
      loading: (_) => null,
      authenticated: (user) {
        // navigate to index/dashboard
        Navigator.pushReplacementNamed(context, '/index');
      },
      error: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
            content: Row(
              children: [
                const Icon(AppIcons.loginError, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Login Failed: $message',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageSelection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final selected = ref.watch(appLocaleProvider);

          Widget langTile(String code, String label, String flag) {
            return ListTile(
              leading: Text(flag, style: const TextStyle(fontSize: 20)),
              title: Text(label),
              trailing: selected == code
                  ? Icon(AppIcons.check, color: AppColors.primary)
                  : null,
              onTap: () async {
                Navigator.pop(context); // close language selector

                // if no change, skip
                final currentLang = ref.read(appLocaleProvider);
                if (currentLang == code) return;

                // persist locally and update provider
                await ref.read(appLocaleProvider.notifier).setLocale(code);

                // show confirmation to user (verify still mounted)
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          AppIcons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(context.l10n.languageUpdatedSuccess),
                      ],
                    ),
                    backgroundColor: Colors.green.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.l10n.selectLanguage,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final code in AppLocalizations.supportedLocales)
                    langTile(
                      code.languageCode,
                      languageLabel(code.languageCode),
                      languageFlag(code.languageCode) ?? '',
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    final isLoading = state.whenOrNull(loading: (_) => true) ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0E21)
          : const Color(0xFFF8F9FC),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 12,
              left: 12,
              child: Consumer(
                builder: (context, ref, _) {
                  final code = ref.watch(appLocaleProvider);
                  final flag = languageFlag(code) ?? '🌐';
                  final name = languageLabel(code);
                  final isDarkBtn =
                      Theme.of(context).brightness == Brightness.dark;
                  return GestureDetector(
                    onTap: _showLanguageSelection,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkBtn
                            ? Colors.white10
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDarkBtn
                              ? Colors.white12
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(flag, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDarkBtn
                                  ? Colors.white70
                                  : const Color(0xFF1A2634),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 16,
                            color: isDarkBtn
                                ? Colors.white54
                                : Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo
                          Center(
                            child: Image.asset(
                              'assets/images/logo2.png',
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Welcome Text
                          Text(
                            context.l10n.welcomeBack,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1A2634),
                                  letterSpacing: -0.5,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),

                          const SizedBox(height: 32),

                          // Form (fields take full width — removed inner card container)
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AppTextField(
                                  controller: _emailCtrl,
                                  labelText: context.l10n.emailAddress,
                                  hintText: context.l10n.emailAddress,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: const Icon(AppIcons.mail),
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? context.l10n.emailRequired
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                AppPasswordField(
                                  controller: _passCtrl,
                                  labelText: context.l10n.password,
                                  hintText: context.l10n.passwordHint,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? context.l10n.passwordRequired
                                      : null,
                                ),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/forgot-password',
                                      );
                                    },
                                    child: Text(
                                      context.l10n.forgotPassword,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDark
                                          ? Colors.white
                                          : AppColors.primary,
                                      foregroundColor: isDark
                                          ? const Color(0xFF1A2634)
                                          : Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: isLoading
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CupertinoActivityIndicator(
                                                      radius: 10,
                                                    ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                context.l10n.signingIn,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            context.l10n.signIn,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                                // _buildSwitchToWorkSpace(context),
                              ],
                            ),
                          ),

                          // Sign Up Link
                          const SizedBox(height: 32),

                          // Wrap(
                          //   alignment: WrapAlignment.center,
                          //   crossAxisAlignment: WrapCrossAlignment.center,
                          //   spacing: 4,
                          //   children: [
                          //     Text(
                          //       "Don't have an account?",
                          //       style: TextStyle(
                          //         color: isDark ? Colors.white70 : const Color(0xFF5A6A7A),
                          //       ),
                          //     ),
                          //     TextButton(
                          //       onPressed: () {
                          //         // Navigate to sign up
                          //       },
                          //       style: TextButton.styleFrom(
                          //         padding: EdgeInsets.zero,
                          //         minimumSize: const Size(50, 30),
                          //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //       ),
                          //       child: const Text(
                          //         'Sign Up',
                          //         style: TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //           color: Color(0xFF4A6FA5),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSwitchToWorkSpace(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/workspace');
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(50, 50),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          context.l10n.switchWorkspace,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : AppColors.primary,
          ),
        ),
      ),
    ],
  );
}
