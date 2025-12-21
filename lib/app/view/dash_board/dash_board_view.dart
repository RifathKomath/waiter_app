import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restuarant_app/app/view/table/table_view.dart';
import 'package:restuarant_app/core/extensions/margin_extension.dart';
import 'package:restuarant_app/shared/utils/screen_utils.dart';
import 'package:restuarant_app/shared/widgets/app_button.dart';
import 'package:restuarant_app/shared/widgets/app_confirmation_popup.dart';

import '../../../core/style/app_text_style.dart';
import '../../../core/style/colors.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../login/login_view.dart';

class DashBoardView extends StatelessWidget {
  const DashBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarClr,
        leading: Icon(Icons.restaurant_rounded, color: whiteClr),
        title: Text(
          "Dashboard",
          style: AppTextStyles.textStyle_700_24.copyWith(color: whiteClr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {
                showCommonDialog(context: context, title: "Logout", body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Are you sure you want to logout ?",style: AppTextStyles.textStyle_500_16,),
                            15.h.hBox,
                            Row(
                              children: [
                                Spacer(),
                                AppButton(label: "Yes",bgColor: appBarClr, isFilled: true,onTap: () {
                                  Screen.openAsNewPage(LoginView());
                                },),
                              ],
                            )
                          ],
                         ));
              },
              child: Icon(Icons.person,color: whiteClr,size: 30,)),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 8),
              child: Text(
                "Welcome back, Faheem!",
                style: AppTextStyles.textStyle_500_16.copyWith(
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),

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
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF282437).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: whiteClr.withOpacity(0.08)),
                        boxShadow: [
                          BoxShadow(
                            color: whiteClr.withOpacity(0.30),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.ac_unit_outlined,
                                color: Color(0xFF8E2DE2),
                              ),
                              10.w.wBox,
                              Text(
                                "AC Section",
                                style: AppTextStyles.textStyle_700_16.copyWith(
                                  color: whiteClr,
                                ),
                              ),
                            ],
                          ),
                          20.h.hBox,
                          customRawText(
                            key: "Total Tables",
                            value: "10",
                            color: whiteClr,
                            icon: Icons.restaurant,
                            iconColor: textColor,
                          ),
                          10.h.hBox,
                          customRawText(
                            key: "Available",
                            value: "4",
                            color: greenNotColor,
                            icon: Icons.circle,
                            iconColor: greenNotColor,
                          ),
                          10.h.hBox,
                          customRawText(
                            key: "Occupied",
                            value: "6",
                            color: darkRed,
                            icon: Icons.circle,
                            iconColor: darkRed,
                          ),
                          20.h.hBox,
                          AppButton(
                            label: "Take Orders",
                            onTap: () {
                              Screen.open(TableView(section: "AC Section",));
                            },
                            isPrefixIconEnabled: true,
                            icon: Icons.note_alt,
                          ),
                        ],
                      ),
                    ),

                    // second container >>>>>>>>>>>>>>>>>>>>>>>>>>
                    30.h.hBox,

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF282437).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: whiteClr.withOpacity(0.08)),
                        boxShadow: [
                          BoxShadow(
                            color: whiteClr.withOpacity(0.30),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                color: Color(0xFF8E2DE2),
                              ),
                              10.w.wBox,
                              Text(
                                "Non-AC Section",
                                style: AppTextStyles.textStyle_700_16.copyWith(
                                  color: whiteClr,
                                ),
                              ),
                            ],
                          ),
                          20.h.hBox,
                          customRawText(
                            key: "Total Tables",
                            value: "8",
                            color: whiteClr,
                            icon: Icons.restaurant,
                            iconColor: textColor,
                          ),
                          10.h.hBox,
                          customRawText(
                            key: "Available",
                            value: "5",
                            color: greenNotColor,
                            icon: Icons.circle,
                            iconColor: greenNotColor,
                          ),
                          10.h.hBox,
                          customRawText(
                            key: "Occupied",
                            value: "3",
                            color: darkRed,
                            icon: Icons.circle,
                            iconColor: darkRed,
                          ),
                          20.h.hBox,
                          AppButton(
                            label: "Take Orders",
                            onTap: () {
                              Screen.open(TableView(section: "Non-AC Section",));
                            },
                            isPrefixIconEnabled: true,
                            icon: Icons.note_alt,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget customRawText({
  required String key,
  required String value,
  required Color color,
  required IconData icon,
  required Color iconColor,
}) {
  return Row(
    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        key,
        style: AppTextStyles.textStyle_400_14.copyWith(color: textColor),
      ),
      Spacer(),
      Icon(icon, color: iconColor, size: 15),
      8.w.wBox,
      Text(
        value,
        textAlign: TextAlign.end,
        style: AppTextStyles.textStyle_600_16.copyWith(color: color),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
