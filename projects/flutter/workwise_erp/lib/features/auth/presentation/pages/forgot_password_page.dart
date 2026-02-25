import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'package:workwise_erp/core/widgets/app_bar.dart';
import 'package:workwise_erp/core/widgets/app_dialog.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/features/auth/domain/usecases/forgot_password.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';
import 'package:workwise_erp/core/extensions/l10n_extension.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();

  static final RegExp _phoneRe = RegExp('^\\+?[0-9]{9,13}\$');
  static final RegExp _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');

  bool _isPhone(String v) => _phoneRe.hasMatch(v.trim());
  bool _isEmail(String v) => _emailRe.hasMatch(v.trim());

  String? _validator(String? v) {
    if (v == null || v.trim().isEmpty) return context.l10n.emailOrPhoneRequired;
    final value = v.trim();
    if (_isEmail(value) || _isPhone(value)) return null;
    return context.l10n.invalidEmailOrPhone;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final identifier = _identifierCtrl.text.trim();

    showAppLoadingDialog(context, message: context.l10n.sendingResetCode);

    final usecase = ref.read(forgotPasswordUseCaseProvider);
    final res = await usecase.call(ForgotPasswordParams(emailOrPhone: identifier));

    // hide loader
    hideAppLoadingDialog(context);

    res.fold(
      (failure) {
        AppDialog.showError(
          context: context, 
          title: context.l10n.requestFailed, 
          message: failure.message,
        );
      },
      (_) {
        // Generic success message to avoid account enumeration
        AppDialog.showSuccess(
          context: context,
          title: context.l10n.codeSent,
          message: context.l10n.codeSentMessage,
          buttonText: context.l10n.verifyOtp,
          onButtonPressed: () {
            Navigator.pop(context); // close dialog
            Navigator.pushNamed(context, '/forgot-password/verify', arguments: identifier);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _identifierCtrl.dispose();
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
        backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: context.l10n.forgotPasswordTitle,
          showBackButton: true,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    // Header with icon
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            primaryColor.withBlue(primaryColor.blue + 50),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    
                    // Main Card
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF151A2E) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Title
                            Text(
                              context.l10n.resetPasswordTitle,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF1A2634),
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            
                            // Description
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: primaryColor.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 20,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      context.l10n.resetPasswordDesc,
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.4,
                                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 28),

                            // Form
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Email/Phone field
                                  AppTextField(
                                    controller: _identifierCtrl,
                                    labelText: context.l10n.emailOrPhone,
                                    hintText: context.l10n.emailOrPhoneHint,
                                    prefixIcon: Icon(
                                      Icons.mail_outline_rounded,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: _validator,
                                   
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Submit button
                                  AppButton(
                                    text: context.l10n.sendResetCode,
                                    textColor: AppColors.white,
                                    onPressed: _submit,
                                    variant: AppButtonVariant.primary,
                                    size: AppButtonSize.large,
                                    fullWidth: true,
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Back to login
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 4,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        context.l10n.rememberPassword,
                                        style: TextStyle(
                                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(50, 30),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          foregroundColor: primaryColor,
                                        ),
                                        child: Text(
                                          context.l10n.signIn,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
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
                    
                    const SizedBox(height: 20),
                    
                    // Help text
                    Text(
                      context.l10n.secureResetNote,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
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