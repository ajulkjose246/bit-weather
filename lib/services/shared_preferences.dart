import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences prefs;
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    prefs = await SharedPreferences.getInstance();
  }

  storePostalCode(String postalCode) {
    prefs.setString("postalCode", postalCode);
  }

  storeLocality(String locality) {
    prefs.setString("locality", locality);
  }

  storeApi(String list) {
    prefs.setString("apiList", list);
  }

  getPostalCode() {
    return prefs.getString("postalCode");
  }

  getLocality() {
    return prefs.getString("locality");
  }

  getApi() {
    return prefs.getString("apiList");
  }
}
