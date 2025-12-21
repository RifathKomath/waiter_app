import 'package:get/get.dart';
import 'package:restuarant_app/app/view/login/login_view.dart';
import 'package:restuarant_app/shared/utils/screen_utils.dart';

class SplashController extends GetxController{
    @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    Future.delayed(const Duration(milliseconds: 2000), () async {
      
  Screen.openAsNewPage(LoginView());
    });
  }
}