import 'package:flutter/material.dart';

import '../../core/style/app_text_style.dart';
import '../../core/style/colors.dart';
import 'app_close_icon.dart';

Future<void> showCommonDialog({
  required BuildContext context,
  required String title,
  required Widget body,
  bool barrierDismissible = false,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: "CommonDialog",
    barrierColor: Colors.black.withOpacity(0.4),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox(); 
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack);

      return ScaleTransition(
        scale: curvedAnimation,
        child: FadeTransition(
          opacity: animation,
          child: Dialog(
            backgroundColor: cardBgLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBgDark,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.textStyle_500_18
                            .copyWith(color: whiteClr),
                      ),
                      AppCloseIcon(
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

               
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: body,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

