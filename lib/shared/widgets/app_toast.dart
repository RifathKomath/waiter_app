import 'package:flutter/material.dart';
import 'package:get/get.dart';

showToast(String message, {bool isError = true}) =>
    Get.snackbar("Message", message,
        backgroundColor: isError ? Colors.red : const Color.fromARGB(255, 99, 209, 103),
        colorText: Colors.white,
        duration: const Duration(seconds: 3));
