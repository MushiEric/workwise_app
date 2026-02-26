import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:workwise_erp/core/widgets/app_bar.dart';
import 'package:workwise_erp/core/widgets/app_dialog.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/features/auth/domain/usecases/forgot_password.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';

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

  static final RegExp _phoneRe = RegExp(r'^\+?[0-9]{9,13}$');
  static final RegExp _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool _isPhone(String v) => _phoneRe.hasMatch(v.trim());
  bool _isEmail(String v) => _emailRe.hasMatch(v.trim());

  @override
  void initState() {
    super.initState();

    // Initialize animations first
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
    if (v == null || v.trim().isEmpty) return 'Email or phone is required';
    final value = v.trim();
    if (_isEmail(value) || _isPhone(value)) return null;
    return 'Enter a valid email or phone';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final identifier = _identifierCtrl.text.trim();

    showAppLoadingDialog(context, message: 'Sending reset code...');

    final usecase = ref.read(forgotPasswordUseCaseProvider);
    final res = await usecase.call(
      ForgotPasswordParams(emailOrPhone: identifier),
    );

    hideAppLoadingDialog(context);

    res.fold(
      (failure) {
        AppDialog.showError(
          context: context,
          title: 'Request Failed',
          message: failure.message,
        );
      },
      (_) {
        AppDialog.showSuccess(
          context: context,
          title: 'Code Sent',
          message:
              'If an account exists, you will receive an OTP by email or SMS.\nPlease check your inbox or messages.',
          buttonText: 'Verify OTP',
          onButtonPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              '/forgot-password/verify',
              arguments: identifier,
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
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
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0A0E21)
            : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: 'Forgot Password',
          foregroundColor: AppColors.white,
          showBackButton: true,
          // backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // Animated Logo
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 600),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.asset(
                                    'assets/images/logo2.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Main Card
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF151A2E)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: primaryColor.withOpacity(0.05),
                                blurRadius: 40,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [                              
                                TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 500),
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
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 12),
                                  
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 28),

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
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                            ),
                                            child: Text(
                                              'Email or Phone',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: _identifierFocus.hasFocus
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
                                            hintText: 'Email or phone number',
                                            prefixIcon: Icon(
                                              _identifierFocus.hasFocus
                                                  ? LucideIcons.mail
                                                  : LucideIcons.mail,
                                              color: _identifierFocus.hasFocus
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
                                            onPressed: _submit,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              foregroundColor: AppColors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              "Reset",
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w600,
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
                                            'Remember your password? ',
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
                                              minimumSize: const Size(50, 30),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              foregroundColor: primaryColor,
                                            ),
                                            child: Text(
                                              'Sign In',
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

                        const SizedBox(height: 24),

                        // Help text with animation
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 700),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Opacity(opacity: value * 0.7, child: child);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.shield,
                                size: 12,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.grey.shade500,
                              ),
                              const SizedBox(width: 6),
                              // Text(
                              //   ' • OTP expires in 10 minutes',
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //     color: isDark ? Colors.white38 : Colors.grey.shade500,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
