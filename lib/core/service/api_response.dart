import 'dart:convert';
import 'dart:developer';
 
import 'package:flutter/cupertino.dart';
 
import 'api.dart';
 
class ApiResponse<T> {
  bool success;
  String msg;
  dynamic data;
  dynamic response;
  String statusCode;
 
  ApiResponse({
    required this.success,
    required this.msg,
    required this.data,
    required this.response,
    required this.statusCode,
  });
 
  factory ApiResponse.fromJson(url, Method method, Object? body,
      Map<String, dynamic> responseData, // <-- Changed to Map<String, dynamic>
      {String? fetchKeyName}) {
    debugPrint("$url ($method)");
 
    if (body != null) log(jsonEncode(body));
 
    var message = "";
    String code = "";
    dynamic data;
 
    try {
      message = responseData["msg"] ?? responseData["message"] ?? "";
      code = (responseData["statusCode"] ?? responseData["statuscode"] ?? responseData["status"] ?? "").toString();
 
      if (fetchKeyName != null) {
        data = responseData[fetchKeyName];
      } else {
        data = responseData["data"] ?? responseData;
      }
      bool isSuccess = code == "200" ||
          code == "201" ||
          code == "201 CREATED" ||
          code == "302";
      return ApiResponse(
        data: data,
        statusCode: code,
        success: isSuccess,
        msg: message,
        response: responseData,
      );
    } catch (e) {
      throw message;
    }
  }
}