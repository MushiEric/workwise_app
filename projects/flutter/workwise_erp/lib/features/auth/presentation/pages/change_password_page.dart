import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workwise_erp/core/widgets/app_bar.dart';
import 'package:workwise_erp/core/widgets/app_button.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';
import 'package:workwise_erp/core/extensions/l10n_extension.dart';
import '../../domain/usecases/change_password_authenticated.dart';
import '../providers/auth_providers.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty)
      return context.l10n.passwordRequired;
    if (value.trim().length < 6) return context.l10n.passwordMinLength;
    return null;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final usecase = ref.read(changePasswordAuthenticatedUseCaseProvider);
    final result = await usecase.call(
      ChangePasswordAuthenticatedParams(
        currentPassword: _currentPasswordCtrl.text.trim(),
        password: _newPasswordCtrl.text.trim(),
        passwordConfirmation: _confirmPasswordCtrl.text.trim(),
      ),
    );

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    result.fold(
      (failure) {
        final message = (failure.message.isNotEmpty)
            ? failure.message
            : context.l10n.tryAgain;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), behavior: SnackBarBehavior.fixed),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.passwordUpdatedMessage),
            behavior: SnackBarBehavior.fixed,
          ),
        );
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.changePassword, actions: [
          
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppPasswordField(
                        controller: _currentPasswordCtrl,
                        labelText: context.l10n.currentPassword,
                        hintText: context.l10n.enterCurrentPassword,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 16),
                      AppPasswordField(
                        controller: _newPasswordCtrl,
                        labelText: context.l10n.newPassword,
                        hintText: context.l10n.enterNewPassword,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 16),
                      AppPasswordField(
                        controller: _confirmPasswordCtrl,
                        labelText: context.l10n.confirmNewPassword,
                        hintText: context.l10n.confirmNewPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.passwordRequired;
                          }
                          if (value != _newPasswordCtrl.text) {
                            return context.l10n.passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      AppButton.primary(
                        text: context.l10n.saveChanges,
                        onPressed: _isSubmitting ? null : _submit,
                        isLoading: _isSubmitting,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
