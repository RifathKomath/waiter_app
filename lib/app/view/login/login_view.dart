import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restuarant_app/core/extensions/margin_extension.dart';

import '../../../core/style/app_text_style.dart';
import '../../../core/style/colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_svg.dart';
import '../../../shared/widgets/app_text_field.dart';

import 'dart:ui';
import 'package:flutter/material.dart';

import '../../controller/login/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF120A23), Color.fromARGB(255, 73, 56, 100)],
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF282437).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Waiter Portal",
                        style: AppTextStyles.textStyle_700_24.copyWith(
                          color: whiteClr,
                          fontSize: 26,
                        ),
                      ),
                      4.h.hBox,
                      Text(
                        "Sign in to start serving",
                        style: AppTextStyles.textStyle_400_12.copyWith(
                          color: textColor,
                        ),
                      ),

                      26.h.hBox,

                      AppTextField(
                        controller: controller.userNameCtrl,
                        textInputType: TextInputType.name,
                        labelText: "Enter your username",
                        label: "Username",
                        useHintInsteadOfLabel: true,
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                        ),
                      ),

                      16.h.hBox,

                      Obx(
                        () => AppTextField(
                          controller: controller.passwordCtrl,
                          labelText: "Enter your password",
                          textInputType: TextInputType.visiblePassword,
                          useHintInsteadOfLabel: true,
                          label: "Password",
                          obscureText: !controller.isPasswordVisible.value,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.white70,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                      ),

                      26.h.hBox,
                      Obx(()=>
                       AppButton(
                          label: "Sign In",
                          isLoaderBtn: controller.isLoading.value,
                          onTap: () {controller.login();},
                          isPrefixIconEnabled: true,
                          icon: Icons.login,
                        ),
                      ),

                      22.h.hBox,
                      Text(
                        "Restaurant Management System",
                        style: AppTextStyles.textStyle_400_12.copyWith(
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
