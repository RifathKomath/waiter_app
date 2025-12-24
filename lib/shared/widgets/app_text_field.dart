import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restuarant_app/core/extensions/margin_extension.dart';
import '../../core/style/app_text_style.dart';
import '../../core/style/colors.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String labelText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final int? minLines;
  final bool obscureText;
  final int? max;
  final bool useHintInsteadOfLabel;
  final bool isRequired;
  final List<TextInputFormatter>? inputFormatters;

  /// 🔹 NEW
  final bool hasElevation;

  const AppTextField({
    super.key,
    this.label,
    required this.controller,
    required this.textInputType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.minLines,
    this.readOnly = false,
    required this.labelText,
    this.onChanged,
    this.maxLength,
    this.obscureText = false,
    this.max,
    this.useHintInsteadOfLabel = false,
    this.isRequired = false,
    this.inputFormatters,
    this.hasElevation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) customTitle(label!, isRequired),
        8.hBox,

        Card(
          elevation: hasElevation ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.zero,
          child: TextFormField(
            maxLength: maxLength,
            minLines: obscureText ? 1 : minLines,
            maxLines: obscureText ? 1 : max,
            readOnly: readOnly,
            obscureText: obscureText,
            controller: controller,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            keyboardType: textInputType,
            validator: validator,
            cursorColor: scaffoldBgDark,
            style: AppTextStyles.textStyle_400_14.copyWith(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: textPrimary,
              counterText: '',
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              hintText: useHintInsteadOfLabel ? labelText : null,
              labelText: useHintInsteadOfLabel ? null : labelText,
              hintStyle: AppTextStyles.textStyle_500_14.copyWith(
                color: Colors.black,
              ),
              labelStyle: AppTextStyles.textStyle_500_14.copyWith(
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget customTitle(final String label, bool isRequired) {
  return RichText(
    text: TextSpan(
      text: label,
      style: AppTextStyles.textStyle_500_14.copyWith(color: whiteClr),
      children: isRequired
          ? const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ]
          : [],
    ),
  );
}
