import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workwise_erp/core/widgets/app_dialog.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/features/auth/domain/usecases/change_password_using_otp.dart';
import 'package:workwise_erp/core/extensions/l10n_extension.dart';

class ChangePasswordUsingOtpPage extends ConsumerStatefulWidget {
  const ChangePasswordUsingOtpPage({super.key});

  @override
  ConsumerState<ChangePasswordUsingOtpPage> createState() => _ChangePasswordUsingOtpPageState();
}

class _ChangePasswordUsingOtpPageState extends ConsumerState<ChangePasswordUsingOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String? _identifier;
  String? _otp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Map) {
      _identifier = arg['identifier'] as String?;
      _otp = arg['otp'] as String?;
    }
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _passwordValidator(String? v) {
    if (v == null || v.isEmpty) return context.l10n.passwordRequired;
    if (v.length < 6) return context.l10n.passwordMinLength;
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final password = _passwordCtrl.text.trim();
    if (_identifier == null || _otp == null) {
      AppDialog.showError(context: context, title: context.l10n.missingData, message: context.l10n.identifierOtpMissing);
      return;
    }

    showAppLoadingDialog(context, message: context.l10n.resettingPassword);
    final usecase = ref.read(changePasswordUsingOtpUseCaseProvider);
    final res = await usecase.call(ChangePasswordUsingOtpParams(emailOrPhone: _identifier!, otp: _otp!, newPassword: password));
    hideAppLoadingDialog(context);

    res.fold(
      (failure) => AppDialog.showError(context: context, title: context.l10n.resetFailed, message: failure.message),
      (_) {
        AppDialog.showSuccess(
          context: context,
          title: context.l10n.passwordChanged,
          message: context.l10n.passwordChangedMessage,
          buttonText: context.l10n.backToLogin,
          onButtonPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.setNewPassword), backgroundColor: isDark ? null : Colors.transparent, elevation: 0, foregroundColor: isDark ? null : const Color(0xFF1A2634)),
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
                      if (_identifier != null) Text(context.l10n.resettingFor(_identifier!), textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppPasswordField(
                              controller: _passwordCtrl,
                              labelText: context.l10n.newPassword,
                              validator: _passwordValidator,
                            ),
                            const SizedBox(height: 12),
                            AppPasswordField(
                              controller: _confirmCtrl,
                              labelText: context.l10n.confirmPassword,
                              validator: (v) => v != _passwordCtrl.text ? context.l10n.passwordsDoNotMatch : null,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: Text(context.l10n.setPassword, style: const TextStyle(fontWeight: FontWeight.bold)),
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
