import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/widgets/app_dialog.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/features/auth/domain/usecases/verify_forgot_password_otp.dart';
import 'package:workwise_erp/core/extensions/l10n_extension.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.verifyResetCode), backgroundColor: isDark ? null : Colors.transparent, elevation: 0, foregroundColor: isDark ? null : const Color(0xFF1A2634)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(context.l10n.enterOtpDesc, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              controller: _identifierCtrl,
                              labelText: context.l10n.emailOrPhone,
                              prefixIcon: const Icon(Icons.mail_outline),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => (v == null || v.trim().isEmpty) ? context.l10n.emailOrPhoneRequired : null,
                            ),
                            const SizedBox(height: 12),
                            AppTextField(
                              controller: _otpCtrl,
                              labelText: context.l10n.otpCode,
                              prefixIcon: const Icon(Icons.confirmation_number_outlined),
                              keyboardType: TextInputType.number,
                              validator: _otpValidator,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: Text(context.l10n.verify, style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.back)),
                    ],
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
