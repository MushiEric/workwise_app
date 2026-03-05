import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/themes/app_colors.dart';

import 'package:workwise_erp/core/widgets/app_dialog.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';
import 'package:workwise_erp/features/auth/presentation/providers/auth_providers.dart';
import 'package:workwise_erp/features/auth/domain/usecases/change_password_using_otp.dart';
import 'package:workwise_erp/core/widgets/app_bar.dart';
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
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.setNewPassword, backgroundColor: AppColors.primary, foregroundColor: Colors.white),
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
                    // if (_identifier != null) Text('Resetting for: $_identifier', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Form(
                      key: _formKey,
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
                          AppPasswordField(
                            controller: _passwordCtrl,
                            // labelText: 'New password',
                            hintText: 'Enter new password',
                            validator: _passwordValidator,
                          ),
                          const SizedBox(height: 12),
                          AppPasswordField(
                            controller: _confirmCtrl,
                            labelText: 'Confirm password',
                            hintText: "Confirm  Password",
                            validator: (v) => v != _passwordCtrl.text ? 'Passwords do not match' : null,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              child: const Text('Set password', style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.white)),
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
