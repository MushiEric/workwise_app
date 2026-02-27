import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Custom text field widget for the app with premium styling
class AppTextField extends StatefulWidget {
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
  final bool showCounter;
  final Color? fillColor;
  final double borderRadius;
  final EdgeInsets? contentPadding;
  final bool floatingLabel;
  final Color? backgroundColor; // New property for custom background

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
    this.showCounter = false,
    this.fillColor,
    this.borderRadius = 12,
    this.contentPadding,
    this.floatingLabel = true,
    this.backgroundColor,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> with TickerProviderStateMixin {
  late final FocusNode _focusNode;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isFocused = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_focusNode.hasFocus) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final hasError = widget.errorText != null || _hasError;
    
    // Check if controller has text
    final bool hasText = widget.controller != null && widget.controller!.text.isNotEmpty;

    // Determine background color with better visibility
    Color getBackgroundColor() {
      if (widget.backgroundColor != null) return widget.backgroundColor!;
      if (widget.fillColor != null) return widget.fillColor!;
      
      if (isDark) {
        return _isFocused 
            ? const Color(0x2AFFFFFF) // More visible when focused
            : const Color(0x1AFFFFFF); // Visible in dark mode
      } else {
        return _isFocused 
            ? const Color(0xFFF0F3F8) // Slightly darker when focused in light mode
            : const Color(0xFFF5F7FA); // Visible light background
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: hasError ? 0 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Floating Label
          if (widget.floatingLabel && widget.labelText != null) ...[
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(
                left: 4,
                bottom: _isFocused || hasText ? 4 : 0,
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: _isFocused || hasText ? 12 : 14,
                  fontWeight: _isFocused ? FontWeight.w600 : FontWeight.w500,
                  color: hasError 
                      ? Colors.red.shade400
                      : _isFocused
                          ? primaryColor
                          : (isDark ? Colors.white70 : Colors.grey.shade700),
                  letterSpacing: 0.3,
                ),
                child: Text(widget.labelText!),
              ),
            ),
          ],
          
          // Input Field with Scale Animation
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: _isFocused && widget.enabled && !widget.readOnly
                    ? [
                        BoxShadow(
                          color: (hasError ? Colors.red : primaryColor).withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: (hasError ? Colors.red : primaryColor).withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    : null,
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                validator: (value) {
                  final error = widget.validator?.call(value);
                  setState(() {
                    _hasError = error != null;
                  });
                  return error;
                },
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  if (widget.validator != null) {
                    final error = widget.validator!(value);
                    setState(() {
                      _hasError = error != null;
                    });
                  }
                },
                onFieldSubmitted: widget.onFieldSubmitted,
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                maxLength: widget.showCounter ? widget.maxLength : null,
                inputFormatters: widget.inputFormatters,
                autofocus: widget.autofocus,
                textCapitalization: widget.textCapitalization,
                onTap: widget.onTap,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: widget.floatingLabel ? null : widget.labelText,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade500,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  errorText: widget.errorText,
                  errorStyle: const TextStyle(
                    fontSize: 12,
                    height: 0.8,
                    letterSpacing: 0.2,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? IconTheme(
                        data: IconThemeData(
                          color: hasError
                              ? Colors.red.shade400
                              : _isFocused
                                  ? primaryColor
                                  : (isDark ? Colors.white70 : Colors.grey.shade600),
                          size: 20,
                        ),
                        child: widget.prefixIcon!,
                      )
                      : null,
                  suffixIcon: widget.suffixIcon != null
                      ? IconTheme(
                          data: IconThemeData(
                            color: hasError
                                ? Colors.red.shade400
                                : _isFocused
                                    ? primaryColor
                                    : (isDark ? Colors.white70 : Colors.grey.shade600),
                            size: 20,
                          ),
                          child: widget.suffixIcon!,
                        )
                      : null,
                  filled: true,
                  fillColor: getBackgroundColor(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: hasError ? Colors.red : primaryColor,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: Colors.red.shade400,
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: Colors.red.shade400,
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white12 : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  contentPadding: widget.contentPadding ?? 
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                  counterText: widget.showCounter ? null : '',
                  counterStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
          
          // Error Message with Animation
          if (hasError && widget.errorText != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.only(left: 12, top: 6),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.alertCircle,
                    size: 12,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.errorText!,
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Enhanced Password text field with visibility toggle
class AppPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final bool showPrefixIcon;
  final bool showStrengthIndicator;
  final Color? backgroundColor; // New property

  const AppPasswordField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.showPrefixIcon = true,
    this.showStrengthIndicator = false,
    this.backgroundColor,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> with TickerProviderStateMixin {
  bool _obscureText = true;
  late final AnimationController _toggleController;
  String? _passwordStrength;
  double _strengthValue = 0.0;

  @override
  void initState() {
    super.initState();
    _toggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _toggleVisibility() {
    if (_obscureText) {
      _toggleController.forward();
    } else {
      _toggleController.reverse();
    }
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _checkPasswordStrength(String password) {
    if (!widget.showStrengthIndicator) return;
    
    double strength = 0;
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;
    
    setState(() {
      _strengthValue = strength;
      if (strength <= 0.25) {
        _passwordStrength = 'Weak';
      } else if (strength <= 0.5) {
        _passwordStrength = 'Fair';
      } else if (strength <= 0.75) {
        _passwordStrength = 'Good';
      } else {
        _passwordStrength = 'Strong';
      }
    });
  }

  @override
  void dispose() {
    _toggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primary;
    
    return Column(
      children: [
        AppTextField(
          controller: widget.controller,
          labelText: widget.labelText,
          hintText: widget.hintText ?? 'Enter your password',
          errorText: widget.errorText,
          focusNode: widget.focusNode,
          obscureText: _obscureText,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: (value) {
            widget.onChanged?.call(value);
            _checkPasswordStrength(value);
          },
          onFieldSubmitted: widget.onFieldSubmitted,
          prefixIcon: widget.showPrefixIcon ? const Icon(LucideIcons.lock) : null,
          suffixIcon: AnimatedBuilder(
            animation: _toggleController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _toggleController.value * 3.14159,
                child: IconButton(
                  icon: Icon(
                    _obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
                  ),
                  onPressed: _toggleVisibility,
                  splashRadius: 20,
                ),
              );
            },
          ),
          backgroundColor: widget.backgroundColor,
        ),
        
        // Password Strength Indicator
        if (widget.showStrengthIndicator && _strengthValue > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _strengthValue,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _strengthValue <= 0.25
                                ? Colors.red.shade400
                                : _strengthValue <= 0.5
                                    ? Colors.orange.shade400
                                    : _strengthValue <= 0.75
                                        ? Colors.blue.shade400
                                        : Colors.green.shade400,
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _passwordStrength!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _strengthValue <= 0.25
                            ? Colors.red.shade400
                            : _strengthValue <= 0.5
                                ? Colors.orange.shade400
                                : _strengthValue <= 0.75
                                    ? Colors.blue.shade400
                                    : Colors.green.shade400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      LucideIcons.info,
                      size: 10,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Use 8+ chars with uppercase, number & symbol',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Enhanced Search text field with visible background
class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final bool autoFocus;
  final VoidCallback? onTap;
  final Color? backgroundColor; // New property

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.focusNode,
    this.autoFocus = false,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    
    final bool hasText = controller != null && controller!.text.isNotEmpty;

    // Determine background color
    Color getBackgroundColor() {
      if (backgroundColor != null) return backgroundColor!;
      return isDark 
          ? const Color(0x2AFFFFFF) // More visible in dark mode
          : const Color(0xFFF0F3F8); // Visible light background
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTap: onTap,
        autofocus: autoFocus,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText ?? 'Search...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white54 : Colors.grey.shade500,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              LucideIcons.search,
              size: 18,
              color: primaryColor,
            ),
          ),
          suffixIcon: hasText
              ? Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(LucideIcons.x, size: 16),
                    onPressed: () {
                      controller?.clear();
                      onClear?.call();
                    },
                    splashRadius: 16,
                  ),
                )
              : null,
          filled: true,
          fillColor: getBackgroundColor(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: primaryColor,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}