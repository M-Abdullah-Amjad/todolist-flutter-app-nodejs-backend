import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'controllers/auth_controller.dart';
import 'controllers/todo_controller.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'views/auth/login_view.dart';
import 'views/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services first
  await Get.putAsync(() => StorageService().init());
  Get.put(ApiService());

  // Initialize controllers after services
  Get.put(AuthController());
  Get.put(TodoController());

  // Check for existing token
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    if (token != null && token!.isNotEmpty) {
      try {
        if (!JwtDecoder.isExpired(token!)) {
          // Initialize todos for existing user
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.find<TodoController>().initializeTodos();
          });
          return const HomeView();
        }
      } catch (e) {
        // Token is invalid, go to login
      }
    }
    return const LoginView();
  }
}