import 'package:flutter/material.dart';
import 'package:restuarant_app/core/style/colors.dart';
import 'package:restuarant_app/shared/widgets/app_svg.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 246, 243),
      body: AppSvg(assetName:"tabàk-kitchen-logo",),
    );
  }
}