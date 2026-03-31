// lib/core/widgets/app_text_field.dart
import 'package:flutter/material.dart';
import '../themes/app_typography.dart';
import '../themes/app_colors.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isRequired;
  final bool obscureText;
  final bool isDropdown;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onPrefixIconPressed;
  final VoidCallback? onSuffixIconPressed;
  final VoidCallback? onDropdownTap;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? minLines;
  final bool enabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? initialValue;

  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.isRequired = false,
    this.obscureText = false,
    this.isDropdown = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onPrefixIconPressed,
    this.onSuffixIconPressed,
    this.onDropdownTap,
    this.onTap,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.initialValue,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late bool _showPassword;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _showPassword = !widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLabel(isDark),
        const SizedBox(height: 8),
        _buildTextField(isDark),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildLabel(bool isDark) {
    return RichText(
      text: TextSpan(
        style: AppTypography.labelStyle.copyWith(
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        children: [
          TextSpan(text: widget.label),
          if (widget.isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.error),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(bool isDark) {
    final effectiveBg = isDark
        ? Colors.white.withOpacity(0.05)
        : AppColors.greyFill;

    return GestureDetector(
      onTap: widget.isDropdown
          ? widget.onDropdownTap
          : (widget.readOnly ? widget.onTap : null),
      child: Container(
        height: (widget.maxLines == 1 && widget.minLines == null) ? 48 : null,
        constraints: BoxConstraints(
          minHeight: (widget.maxLines > 1 || widget.minLines != null) ? 40 : 0,
        ),
        decoration: BoxDecoration(
          color: effectiveBg,
          borderRadius: BorderRadius.circular(AppTypography.borderRadius),
          border: Border.all(
            color: isDark ? Colors.white24 : AppColors.greyBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            if (widget.prefixIcon != null)
              _buildIconButton(
                icon: widget.prefixIcon!,
                onPressed: widget.onPrefixIconPressed,
              ),
            // AbsorbPointer wraps only the text input so that suffix/prefix
            // icon buttons remain interactive even when readOnly is true.
            Expanded(
              child: AbsorbPointer(
                absorbing: widget.isDropdown || widget.readOnly,
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  obscureText: _obscureText,
                  readOnly: widget.readOnly,
                  validator: widget.validator,
                  maxLines: widget.maxLines,
                  enabled: widget.enabled,
                  focusNode: widget.focusNode,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: widget.onSubmitted,
                  initialValue: widget.initialValue,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTypography.hintStyle.copyWith(
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: (widget.maxLines > 1 || widget.minLines != null)
                          ? 8
                          : 12,
                    ),
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
            if (widget.isDropdown)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                  size: 22,
                ),
              ),
            if (widget.suffixIcon != null && !widget.isDropdown)
              _buildIconButton(
                icon: widget.suffixIcon!,
                onPressed: widget.onSuffixIconPressed,
              ),
            if (widget.obscureText && !widget.isDropdown)
              _buildIconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.greyText,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                    _showPassword = !_showPassword;
                  });
                  if (widget.onSuffixIconPressed != null) {
                    widget.onSuffixIconPressed!();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({required Widget icon, VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      padding: EdgeInsets.zero,
    );
  }
}
