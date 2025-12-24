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
   
    this.height = 45,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: TextFormField(
        controller: controller,
        cursorColor: scaffoldBgDark,
        onChanged: onChanged,
        style: AppTextStyles.textStyle_400_14.copyWith(
          decoration: TextDecoration.none,color: textPrimary
        ),
        decoration: InputDecoration(
          filled: true,
          
          fillColor: cardBgLight,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:  BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: const Icon(Icons.search, size: 16,color: textPrimary,),
          hintStyle: AppTextStyles.textStyle_400_14.copyWith(color: textPrimary),
        ),
      ),
    );
  }
}
