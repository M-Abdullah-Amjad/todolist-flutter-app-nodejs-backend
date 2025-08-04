import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/todo_model.dart';

class ApiService extends GetxService {
  static const String baseUrl = '';
  static String? authToken;

  // Authentication APIs
  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      final data = json.decode(response.body);
      if (data['status'] == true) {
        authToken = data['token'];
      }
      return data;
    } catch (e) {
      return {'status': false, 'error': e.toString()};
    }
  }

  // Todo APIs
  Future<Map<String, dynamic>> createTodo(String title, String description, String status) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/todos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'title': title,
          'description': description,
          'status': status,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllTodos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/todos'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateTodo(String id, String title, String description, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/todos/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'title': title,
          'description': description,
          'status': status,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteTodo(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/todos/$id'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getTodosByStatus(String status) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/todos/status/$status'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': false, 'error': e.toString()};
    }
  }
}
