import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceManager {
  static Future<String?> loadDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('serial_num');
  }

  static Future<void> clearDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('serial_num');
  }
}