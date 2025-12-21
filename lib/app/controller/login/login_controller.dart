import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../shared/utils/screen_utils.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../view/dash_board/dash_board_view.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  final TextEditingController userNameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // RxBool? isRemember = false.obs;

  // void rememberFunction(bool value) {
  //   isRemember?.value = value;
  // }

  var userName = "Faheem";
  var password = "Faheem";

  void login() async {
  try {
    isLoading.value = true;

    if (userNameCtrl.text.isEmpty) {
      showToast("Please Enter User Name");
      return;
    } else if (passwordCtrl.text.isEmpty) {
      showToast("Please Enter Password");
      return;
    } else if (userNameCtrl.text == userName &&
        passwordCtrl.text == password) {
        await  Future.delayed(Duration(seconds: 1));
          showToast("Login Completed Successfully", isError: false);
       Screen.openAsNewPage(DashBoardView());
      
    } else {
      showToast("Login Failed");
    }
  } catch (e) {
    print("Login failed $e");
  } finally {
    isLoading.value = false;
  }
}
}
