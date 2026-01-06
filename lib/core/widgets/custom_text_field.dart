import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/theme/app_colors.dart';
import '../config/theme/app_dimensions.dart';

/// CustomTextField - Reusable text input widget
/// Har jagah same design maintain karta hai
class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final String? helperText;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    this.prefixText,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.helperText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      style: TextStyle(
        fontSize: 16,
        color: widget.enabled ? AppColors.textPrimary : AppColors.textSecondary,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helperText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(
          widget.prefixIcon,
          color: AppColors.textSecondary,
          size: AppDimensions.iconM,
        )
            : null,
        prefixText: widget.prefixText,
        prefixStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        suffixIcon: _buildSuffixIcon(),
        filled: true,
        fillColor: widget.enabled ? AppColors.surface : AppColors.surfaceVariant,

        // Border styling
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),

        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceM,
          vertical: AppDimensions.spaceM,
        ),
        counterText: widget.maxLength != null ? null : '',
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      inputFormatters: widget.inputFormatters,
    );
  }

  Widget? _buildSuffixIcon() {
    // Password visibility toggle
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
          size: AppDimensions.iconM,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }
}

// ============================================
// Specialized Text Field Variants
// ============================================

/// EmailTextField - Email input with validation
class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const EmailTextField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: 'Email',
      hint: 'Enter your email',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      validator: validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
    );
  }
}

/// PhoneTextField - Phone input with +91 prefix and validation
class PhoneTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const PhoneTextField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: 'Phone Number',
      hint: 'Enter 10-digit number',
      prefixIcon: Icons.phone_outlined,
      prefixText: '+91 ',
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length != 10) {
              return 'Please enter a valid 10-digit number';
            }
            return null;
          },
    );
  }
}

/// PasswordTextField - Password input with visibility toggle
class PasswordTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const PasswordTextField({
    super.key,
    this.controller,
    this.label,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label ?? 'Password',
      hint: 'Enter your password',
      prefixIcon: Icons.lock_outline,
      obscureText: true,
      onChanged: onChanged,
      validator: validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
    );
  }
}

/* ============================================
   USAGE EXAMPLES
   ============================================

// 1. Basic Text Field
CustomTextField(
  controller: _nameController,
  label: 'Full Name',
  hint: 'Enter your name',
  prefixIcon: Icons.person_outline,
)

// 2. Email Field (pre-built)
EmailTextField(
  controller: _emailController,
)

// 3. Phone Field (pre-built)
PhoneTextField(
  controller: _phoneController,
)

// 4. Password Field (pre-built)
PasswordTextField(
  controller: _passwordController,
)

// 5. Custom Validation
CustomTextField(
  controller: _ageController,
  label: 'Age',
  keyboardType: TextInputType.number,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter age';
    }
    if (int.parse(value) < 18) {
      return 'Must be 18 or older';
    }
    return null;
  },
)

// 6. Multiline Text Field
CustomTextField(
  controller: _addressController,
  label: 'Address',
  maxLines: 3,
)

// 7. Number Input Only
CustomTextField(
  controller: _amountController,
  label: 'Amount',
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
)

// 8. Read-Only Field
CustomTextField(
  controller: _emailController,
  label: 'Email (Verified)',
  readOnly: true,
  enabled: false,
)

============================================ */