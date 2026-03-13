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
  final String? Function(String?)? validator;
  final int maxLines;
  final bool enabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const AppTextField({
    Key? key,
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
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLabel(),
        const SizedBox(height: 8),
        _buildTextField(),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildLabel() {
    return RichText(
      text: TextSpan(
        style: AppTypography.labelStyle,
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

  Widget _buildTextField() {
    return GestureDetector(
      onTap: widget.isDropdown ? widget.onDropdownTap : null,
      child: AbsorbPointer(
        absorbing: widget.isDropdown,
        child: Container(
          height: widget.maxLines > 1 ? null : 56,
          decoration: BoxDecoration(
            color: widget.enabled ? AppColors.greyFill : AppColors.greyBorder,
            borderRadius: BorderRadius.circular(AppTypography.borderRadius),
            border: Border.all(
              color: AppColors.greyBorder,
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
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  obscureText: _obscureText,
                  validator: widget.validator,
                  maxLines: widget.maxLines,
                  enabled: widget.enabled,
                  focusNode: widget.focusNode,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTypography.hintStyle,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (widget.isDropdown)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.greyText,
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
      ),
    );
  }

  Widget _buildIconButton({
    required Widget icon,
    VoidCallback? onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      constraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),
      padding: EdgeInsets.zero,
    );
  }
}