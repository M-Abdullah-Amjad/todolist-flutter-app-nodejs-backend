import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginapp_nodejs/controllers/todo_controller.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';
import '../views/auth/login_view.dart';

class AuthController extends GetxController {
  late final ApiService _apiService;
  late final StorageService _storageService;

  final RxBool isLoading = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxString userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ApiService>();
    _storageService = Get.find<StorageService>();
    _loadUserData();
  }

  void _loadUserData() {
    userEmail.value = _storageService.getUserEmail() ?? '';
  }

  Future<bool> register(String email, String password) async {
    isLoading.value = true;

    try {
      final result = await _apiService.register(email, password);

      if (result['status'] == true) {
        Get.snackbar(
          'Success',
          'Registration successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          result['error'] ?? 'Registration failed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;

    try {
      final result = await _apiService.login(email, password);

      if (result['status'] == true) {
        await _storageService.setToken(result['token']);
        await _storageService.setUserEmail(email);
        userEmail.value = email;

        // Initialize todos after successful login
        await Get.find<TodoController>().initializeTodos();

        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          result['error'] ?? 'Login failed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storageService.removeToken();
    currentUser.value = null;
    userEmail.value = '';
    Get.offAll(() => const LoginView());
  }
}