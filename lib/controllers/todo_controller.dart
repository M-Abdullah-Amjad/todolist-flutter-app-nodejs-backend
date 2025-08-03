import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/todo_model.dart';
import '../services/api_service.dart';

class TodoController extends GetxController {
  late final ApiService _apiService;

  final RxList<Todo> todos = <Todo>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedStatus = 'all'.obs;
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ApiService>();
    // Don't auto-load todos here, wait for authentication
  }

  // Call this method after successful login
  Future<void> initializeTodos() async {
    if (!isInitialized.value) {
      await loadTodos();
      isInitialized.value = true;
    }
  }

  Future<void> loadTodos() async {
    isLoading.value = true;

    try {
      final result = await _apiService.getAllTodos();

      if (result['status'] == true) {
        final List<Todo> todoList = (result['todos'] as List)
            .map((todo) => Todo.fromJson(todo))
            .toList();
        todos.value = todoList;

        // Show success message only if todos were loaded
        if (todoList.isNotEmpty) {
          Get.snackbar(
            'Success',
            'Loaded ${todoList.length} todos',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        Get.snackbar(
          'Error',
          result['error'] ?? 'Failed to load todos',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createTodo(String title, String description, String status) async {
    isLoading.value = true;

    try {
      final result = await _apiService.createTodo(title, description, status);

      if (result['status'] == true) {
        await loadTodos(); // Reload todos
        Get.snackbar(
          'Success',
          'Todo created successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          result['error'] ?? 'Failed to create todo',
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

  Future<bool> updateTodo(String id, String title, String description, String status) async {
    isLoading.value = true;

    try {
      final result = await _apiService.updateTodo(id, title, description, status);

      if (result['status'] == true) {
        await loadTodos(); // Reload todos
        Get.snackbar(
          'Success',
          'Todo updated successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          result['error'] ?? 'Failed to update todo',
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

  Future<bool> deleteTodo(String id) async {
    isLoading.value = true;

    try {
      final result = await _apiService.deleteTodo(id);

      if (result['status'] == true) {
        await loadTodos(); // Reload todos
        Get.snackbar(
          'Success',
          'Todo deleted successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          result['error'] ?? 'Failed to delete todo',
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

  List<Todo> get filteredTodos {
    if (selectedStatus.value == 'all') {
      return todos;
    }
    return todos.where((todo) => todo.status == selectedStatus.value).toList();
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
  }

  // Refresh todos manually
  Future<void> refreshTodos() async {
    await loadTodos();
  }
}