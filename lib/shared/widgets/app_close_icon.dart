import 'package:flutter/material.dart';

import '../../core/style/colors.dart';

class AppCloseIcon extends StatelessWidget {
  final VoidCallback onTap;
  const AppCloseIcon({
    super.key,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration( borderRadius: BorderRadius.circular(100)),
        child: Icon(Icons.close,color: textPrimary,),
      ),
    );
  }
}