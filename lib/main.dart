import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:restuarant_app/app/controller/splash/splash_controller.dart';
import 'package:restuarant_app/app/view/splash/splash_view.dart';
import 'package:restuarant_app/core/style/colors.dart';

import 'app/view/dash_board/dash_board_view.dart';
import 'app/view/login/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: BindingsBuilder((){
            Get.put(SplashController());
          }),
          title: 'Restuarent app',
          theme: ThemeData(scaffoldBackgroundColor: whiteClr),
          home: SplashView(),
        );
      },
    );
  }
}
