import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';

import 'package:workwise_erp/core/widgets/app_dialog.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/features/auth/domain/usecases/verify_forgot_password_otp.dart';
import 'package:workwise_erp/core/widgets/app_bar.dart';

class VerifyForgotPasswordOtpPage extends ConsumerStatefulWidget {
  const VerifyForgotPasswordOtpPage({super.key});

  @override
  ConsumerState<VerifyForgotPasswordOtpPage> createState() => _VerifyForgotPasswordOtpPageState();
}

class _VerifyForgotPasswordOtpPageState extends ConsumerState<VerifyForgotPasswordOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String && arg.isNotEmpty) {
      _identifierCtrl.text = arg;
    }
  }

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  String? _otpValidator(String? v) {
    if (v == null || v.trim().isEmpty) return context.l10n.otpRequired;
    final trimmed = v.trim();
    if (!RegExp('^\\d{4,8}\$').hasMatch(trimmed)) return context.l10n.invalidOtp;
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final identifier = _identifierCtrl.text.trim();
    final otp = _otpCtrl.text.trim();

    showAppLoadingDialog(context, message: context.l10n.verifyingCode);
    final usecase = ref.read(verifyForgotPasswordOtpUseCaseProvider);
    final res = await usecase.call(VerifyForgotPasswordOtpParams(emailOrPhone: identifier, otp: otp));
    hideAppLoadingDialog(context);

    res.fold(
      (failure) => AppDialog.showError(context: context, title: context.l10n.verificationFailed, message: failure.message),
      (_) {
        Navigator.pushNamed(context, '/forgot-password/change', arguments: {'identifier': identifier, 'otp': otp});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title:'Verify Reset Code', backgroundColor:AppColors.primary, foregroundColor: Colors.white),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(2),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                     TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 50,
                          height: 50,
                          
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
                    // Text('Enter the 6‑digit code we sent to your email or phone', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            controller: _identifierCtrl,
                            labelText: 'Email or phone',
                            prefixIcon: const Icon(Icons.mail_outline),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Identifier is required' : null,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            controller: _otpCtrl,
                            labelText: 'OTP code',
                            hintText: 'Enter the code',
                            prefixIcon: const Icon(Icons.confirmation_number_outlined),
                            keyboardType: TextInputType.number,
                            validator: _otpValidator,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: AppColors.primary),
                              child: const Text('Verify', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back')),
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
