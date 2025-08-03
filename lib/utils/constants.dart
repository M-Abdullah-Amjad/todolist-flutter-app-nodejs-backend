class AppConstants {
  static const String appName = 'Todo App';
  static const String baseUrl = 'https://todo-nodejs-flutter-app.vercel.app';

  // API Endpoints
  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
  static const String todosEndpoint = '/todos';

  // Status values
  static const List<String> todoStatuses = [
    'pending',
    'in-progress',
    'completed',
  ];
}