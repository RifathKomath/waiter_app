import 'package:flutter/material.dart';
import '../../core/style/app_text_style.dart';
import '../../core/style/colors.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  final double height;

  const AppSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search...',
   
    this.height = 35,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.textStyle_400_14.copyWith(
          decoration: TextDecoration.none,color: whiteClr
        ),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: whiteClr),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: whiteClr),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: textColor, width: 2.0),
          ),
          suffixIcon: const Icon(Icons.search, size: 16,color: textColor,),
          hintStyle: AppTextStyles.textStyle_400_14.copyWith(color: whiteClr),
        ),
      ),
    );
  }
}
