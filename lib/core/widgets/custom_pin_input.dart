import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/theme/app_colors.dart';
import '../config/theme/app_dimensions.dart';

/// CustomPinInput - Reusable OTP/PIN input widget
/// Auto-focus, validation, backspace support included
class CustomPinInput extends StatefulWidget {
  final int length;
  final void Function(String) onCompleted;
  final void Function(String)? onChanged;
  final double fieldWidth;
  final double fieldHeight;
  final double? borderRadius;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final TextStyle? textStyle;

  const CustomPinInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
    this.fieldWidth = 48,
    this.fieldHeight = 56,
    this.borderRadius,
    this.obscureText = false,
    this.keyboardType = TextInputType.number,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textStyle,
  });

  @override
  State<CustomPinInput> createState() => CustomPinInputState();
}

class CustomPinInputState extends State<CustomPinInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<bool> _hasError;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
          (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
          (index) => FocusNode(),
    );
    _hasError = List.generate(widget.length, (index) => false);

    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNodes.isNotEmpty) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    setState(() {
      _hasError[index] = false;
    });

    if (value.isNotEmpty) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field filled, check if all filled
        _focusNodes[index].unfocus();
        _checkCompletion();
      }
    }

    // Call onChanged callback
    if (widget.onChanged != null) {
      final pin = _controllers.map((c) => c.text).join();
      widget.onChanged!(pin);
    }
  }

  void _checkCompletion() {
    final pin = _controllers.map((c) => c.text).join();
    if (pin.length == widget.length) {
      widget.onCompleted(pin);
    }
  }

  // Public method to clear all fields
  void clear() {
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _hasError = List.generate(widget.length, (index) => false);
    });
    _focusNodes[0].requestFocus();
  }

  // Public method to show error
  void showError() {
    setState(() {
      _hasError = List.generate(widget.length, (index) => true);
    });
  }

  // Public method to get current value
  String getValue() {
    return _controllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.length,
            (index) => _buildPinField(index),
      ),
    );
  }

  Widget _buildPinField(int index) {
    return SizedBox(
      width: widget.fieldWidth,
      height: widget.fieldHeight,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: widget.keyboardType,
        maxLength: 1,
        obscureText: widget.obscureText,
        style: widget.textStyle ??
            TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          filled: true,
          fillColor: widget.fillColor ?? AppColors.surface,

          // Normal border
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppDimensions.radiusM,
            ),
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.border,
              width: 1.5,
            ),
          ),

          // Enabled border
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppDimensions.radiusM,
            ),
            borderSide: BorderSide(
              color: _hasError[index]
                  ? (widget.errorBorderColor ?? AppColors.error)
                  : (widget.borderColor ?? AppColors.border),
              width: 1.5,
            ),
          ),

          // Focused border
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppDimensions.radiusM,
            ),
            borderSide: BorderSide(
              color: _hasError[index]
                  ? (widget.errorBorderColor ?? AppColors.error)
                  : (widget.focusedBorderColor ?? AppColors.primary),
              width: 2,
            ),
          ),

          // Error border
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppDimensions.radiusM,
            ),
            borderSide: BorderSide(
              color: widget.errorBorderColor ?? AppColors.error,
              width: 1.5,
            ),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) => _onChanged(value, index),
        onTap: () {
          // Select all on tap
          if (_controllers[index].text.isNotEmpty) {
            _controllers[index].selection = TextSelection(
              baseOffset: 0,
              extentOffset: _controllers[index].text.length,
            );
          }
        },
      ),
    );
  }
}

/* ============================================
   USAGE EXAMPLES
   ============================================

// 1. Basic 6-digit OTP
final GlobalKey<CustomPinInputState> _pinKey = GlobalKey();

CustomPinInput(
  key: _pinKey,
  length: 6,
  onCompleted: (pin) {
    print('PIN entered: $pin');
    // Verify OTP
  },
)

// 2. With custom styling
CustomPinInput(
  length: 6,
  fieldWidth: 56,
  fieldHeight: 64,
  borderRadius: 16,
  fillColor: Colors.grey[100],
  focusedBorderColor: Colors.blue,
  onCompleted: (pin) {
    // Handle PIN
  },
)

// 3. 4-digit PIN (obscured)
CustomPinInput(
  length: 4,
  obscureText: true,
  fieldWidth: 60,
  fieldHeight: 60,
  onCompleted: (pin) {
    // Handle PIN
  },
)

// 4. With onChange callback
CustomPinInput(
  length: 6,
  onChanged: (value) {
    print('Current value: $value');
  },
  onCompleted: (pin) {
    print('Complete: $pin');
  },
)

// 5. Clear PIN programmatically
_pinKey.currentState?.clear();

// 6. Show error
_pinKey.currentState?.showError();

// 7. Get current value
String currentPin = _pinKey.currentState?.getValue() ?? '';

// 8. Responsive sizing
CustomPinInput(
  length: 6,
  fieldWidth: AppDimensions.responsive(
    context,
    mobile: 48,
    tablet: 56,
    desktop: 64,
  ),
  fieldHeight: AppDimensions.responsive(
    context,
    mobile: 56,
    tablet: 64,
    desktop: 72,
  ),
  onCompleted: (pin) {},
)

============================================ */