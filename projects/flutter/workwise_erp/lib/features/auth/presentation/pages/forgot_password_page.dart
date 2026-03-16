import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../../core/themes/app_icons.dart';

import 'package:workwise_erp/core/widgets/app_bar.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';
// import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/features/auth/domain/usecases/forgot_password.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import 'package:workwise_erp/core/extensions/l10n_extension.dart';
import 'package:workwise_erp/core/provider/navigator_key_provider.dart';
import 'package:flutter/cupertino.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();
  final FocusNode _identifierFocus = FocusNode();

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  late final GlobalKey<ScaffoldMessengerState> _messengerKey;

  static final RegExp _phoneRe = RegExp(r'^\+?[0-9]{9,13}$');
  static final RegExp _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool _isPhone(String v) => _phoneRe.hasMatch(v.trim());
  bool _isEmail(String v) => _emailRe.hasMatch(v.trim());
  bool _isSubmitting = false;
  @override
  void initState() {
    super.initState();

    // Initialize animations first
    _messengerKey = ref.read(scaffoldMessengerKeyProvider);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  String? _validator(String? v) {
    if (v == null || v.trim().isEmpty) return context.l10n.emailOrPhoneRequired;
    final value = v.trim();
    if (_isEmail(value) || _isPhone(value)) return null;
    return context.l10n.invalidEmailOrPhone;
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    final identifier = _identifierCtrl.text.trim();

    setState(() => _isSubmitting = true);

    try {
      final usecase = ref.read(forgotPasswordUseCaseProvider);
      final res = await usecase.call(
        ForgotPasswordParams(emailOrPhone: identifier),
      );

      res.fold(
        (failure) {
          _messengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        },
        (message) {
          _messengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: context.l10n.verifyOtp,
                textColor: Colors.white,
                onPressed: () {
                  _messengerKey.currentState?.clearSnackBars();
                  ref
                      .read(navigatorKeyProvider)
                      .currentState
                      ?.pushNamed(
                        '/forgot-password/verify',
                        arguments: identifier,
                      );
                },
              ),
            ),
          );
        },
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    // Ensure any SnackBars shown on this screen are removed when the user
    // navigates away (e.g., back to login or to OTP verification).
    _messengerKey.currentState?.clearSnackBars();

    _animationController.dispose();
    _identifierCtrl.dispose();
    _identifierFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: PopScope(
        onPopInvokedWithResult: (didPop, _) {
          _messengerKey.currentState?.clearSnackBars();
        },
        child: Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF0A0E21)
              : const Color(0xFFF8F9FC),
          appBar: CustomAppBar(
            title: context.l10n.forgotPasswordTitle,
            foregroundColor: AppColors.white,
            showBackButton: true,
            // backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            // Main Card
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(22.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      curve: Curves.easeOut,
                                      builder: (context, value, child) {
                                        return Opacity(
                                          opacity: value,
                                          child: Transform.translate(
                                            offset: Offset(0, 10 * (1 - value)),
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),

                                    // Form
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TweenAnimationBuilder<double>(
                                                duration: const Duration(
                                                  milliseconds: 600,
                                                ),
                                                tween: Tween(
                                                  begin: 0.0,
                                                  end: 1.0,
                                                ),
                                                curve: Curves.easeOutBack,
                                                builder: (context, value, child) {
                                                  return Transform.scale(
                                                    scale: value,
                                                    child: Center(
                                                      child: Container(
                                                        width: 150,
                                                        height: 150,

                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                24,
                                                              ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                24,
                                                              ),
                                                          child: Image.asset(
                                                            'assets/images/logo2.png',
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                padding: const EdgeInsets.only(
                                                  left: 4,
                                                  bottom: 0,
                                                ),
                                                child: Text(
                                                  context.l10n.emailOrPhone,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        _identifierFocus
                                                            .hasFocus
                                                        ? primaryColor
                                                        : (isDark
                                                              ? Colors.white70
                                                              : Colors
                                                                    .grey
                                                                    .shade700),
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ),
                                              AppTextField(
                                                controller: _identifierCtrl,
                                                focusNode: _identifierFocus,
                                                hintText: context
                                                    .l10n
                                                    .emailOrPhoneHint,
                                                prefixIcon: Icon(
                                                  _identifierFocus.hasFocus
                                                      ? AppIcons.mail
                                                      : AppIcons.mail,
                                                  color:
                                                      _identifierFocus.hasFocus
                                                      ? primaryColor
                                                      : (isDark
                                                            ? Colors.white54
                                                            : Colors
                                                                  .grey
                                                                  .shade500),
                                                  size: 20,
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                validator: _validator,
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 32),

                                          // Submit button with animation
                                          TweenAnimationBuilder<double>(
                                            duration: const Duration(
                                              milliseconds: 600,
                                            ),
                                            tween: Tween(begin: 0.0, end: 1.0),
                                            curve: Curves.easeOutCubic,
                                            builder: (context, value, child) {
                                              return Opacity(
                                                opacity: value,
                                                child: Transform.translate(
                                                  offset: Offset(
                                                    0,
                                                    20 * (1 - value),
                                                  ),
                                                  child: child,
                                                ),
                                              );
                                            },
                                            child: SizedBox(
                                              height: 54,
                                              child: ElevatedButton(
                                                onPressed: _isSubmitting
                                                    ? null
                                                    : _submit,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.primary,
                                                  foregroundColor:
                                                      AppColors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                child: _isSubmitting
                                                    ? const CupertinoActivityIndicator(
                                                        color: AppColors.white,
                                                      )
                                                    : Text(
                                                        context
                                                            .l10n
                                                            .sendResetCode,
                                                        style: const TextStyle(
                                                          color:
                                                              AppColors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),

                                          // Back to login with enhanced styling
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${context.l10n.rememberPassword} ',
                                                style: TextStyle(
                                                  color: isDark
                                                      ? Colors.white54
                                                      : Colors.grey.shade600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  minimumSize: const Size(
                                                    50,
                                                    30,
                                                  ),
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  foregroundColor: primaryColor,
                                                ),
                                                child: Text(
                                                  context.l10n.signIn,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 94),
                          ],
                        ),
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
