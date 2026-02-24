import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Custom text field widget for the app
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;
  final bool readOnly;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      readOnly: readOnly,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? const Color(0x08FFFFFF) :  AppColors.surfaceVariantLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

/// Password text field with visibility toggle
class AppPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final bool showPrefixIcon;

  const AppPasswordField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction,
    this.showPrefixIcon = true,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      labelText: widget.labelText ?? 'Password',
      hintText: widget.hintText ?? 'Enter your password',
      errorText: widget.errorText,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
    
      prefixIcon: widget.showPrefixIcon ? const Icon(LucideIcons.lock) : null,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
        ),
        onPressed: _toggleVisibility,
      ),
    );
  }
}

/// Search text field
class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText ?? 'Search...',
        prefixIcon: const Icon(LucideIcons.search),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: const Icon(LucideIcons.x),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
            : null,
        filled: true,
        fillColor: AppColors.surfaceVariantLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:BorderSide(),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}