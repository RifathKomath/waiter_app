import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPreferences? sharedPref;

  Future<SharedPreferences> get _instance async =>
      sharedPref ??= await SharedPreferences.getInstance();

  Future<SharedPreferences> init() async {
    sharedPref = await _instance;
    return sharedPref!;
  }

  Future<bool> save({required String key, required dynamic value}) async {
    if (sharedPref == null) await init();
    switch (value.runtimeType) {
      case const (String):
        return await sharedPref!.setString(key, value);
      case const (bool):
        return await sharedPref!.setBool(key, value);
      case const (int):
        return await sharedPref!.setInt(key, value);
      case const (double):
        return await sharedPref!.setDouble(key, value);
      default:
        return await sharedPref!.setString(key, jsonEncode(value));
    }
  }

  // getClinicData() async {
  //   if (sharedPref == null) await init();
  //   final String? clinicDataJson = sharedPref?.getString("clinicdata");

  //   if (clinicDataJson == null ||
  //       clinicDataJson.isEmpty ||
  //       clinicDataJson == "null") {
  //     return null;
  //   }

  //   try {
  //     final decoded = jsonDecode(clinicDataJson);

  //     if (decoded == null || decoded is! Map<String, dynamic>) {
  //       return null;
  //     }

  //     clinicInfo = ClinicDetails.fromJson(decoded);
  //     return clinicInfo;
  //   } catch (e) {
  //     print("Error parsing clinic data: $e");
  //     return null;
  //   }
  // }

  // getClinicSaveData() async {
  //   if (sharedPref == null) await init();
  //   final String? clinicSaveDataJson = sharedPref?.getString("clinicsavedata");

  //   if (clinicSaveDataJson == null ||
  //       clinicSaveDataJson.isEmpty ||
  //       clinicSaveDataJson == "null") {
  //     return null;
  //   }

  //   try {
  //     final decoded = jsonDecode(clinicSaveDataJson);

  //     if (decoded == null || decoded is! Map<String, dynamic>) {
  //       return null;
  //     }

  //     clinicSaveInfo = ClinicSaveData.fromJson(decoded);
  //     return clinicSaveInfo;
  //   } catch (e) {
  //     print("Error parsing clinic save data: $e");
  //     return null;
  //   }
  // }

  logout() async {
    if (sharedPref == null) await init();
    await sharedPref!.clear();
    // clinicInfo = null;
    // clinicSaveInfo = null;
    await Future.delayed(const Duration(milliseconds: 200));
    // Screen.openAsNewPage(AuthView());
  }
}
