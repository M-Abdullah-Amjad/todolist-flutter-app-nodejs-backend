import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setToken(String token) async {
    return await _prefs.setString('token', token);
  }

  String? getToken() {
    return _prefs.getString('token');
  }

  Future<bool> removeToken() async {
    return await _prefs.remove('token');
  }

  Future<bool> setUserEmail(String email) async {
    return await _prefs.setString('userEmail', email);
  }

  String? getUserEmail() {
    return _prefs.getString('userEmail');
  }
}