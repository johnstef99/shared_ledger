import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SLTextField extends StatelessWidget {
  const SLTextField({
    super.key,
    this.label,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.textFieldKey,
    this.initialValue,
    this.maxLines,
  });

  final String? label;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final Key? textFieldKey;
  final String? initialValue;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 350),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          TextFormField(
            inputFormatters: [
              if (keyboardType.decimal == true) _CommaTextInputFormatter(),
            ],
            maxLines: obscureText ? 1 : maxLines,
            initialValue: initialValue,
            key: textFieldKey,
            focusNode: focusNode,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            obscureText: obscureText,
            onSaved: onSaved,
            controller: controller,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              isDense: true,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      TextEditingValue(
        text: newValue.text.replaceAll(',', '.'),
        selection: newValue.selection,
      );
}
