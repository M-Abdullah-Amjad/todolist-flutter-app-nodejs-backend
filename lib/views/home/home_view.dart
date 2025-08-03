import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/todo_controller.dart';
import '../widgets/add_todo_dialog.dart';
import 'todo_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final TodoController todoController = Get.find<TodoController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                authController.logout();
              } else if (value == 'refresh') {
                todoController.refreshTodos();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Refresh Todos'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // User info with todo count
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Obx(() => Column(
              children: [
                const Icon(Icons.person, size: 50, color: Colors.red),
                const SizedBox(height: 8),
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  authController.userEmail.value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => Text(
                  '${todoController.todos.length} total todos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                )),
              ],
            )),
          ),

          // Status filter
          Container(
            padding: const EdgeInsets.all(16),
            child: Obx(() => Row(
              children: [
                const Text('Filter: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('All (${todoController.todos.length})'),
                  selected: todoController.selectedStatus.value == 'all',
                  onSelected: (selected) {
                    if (selected) todoController.setStatusFilter('all');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Pending (${todoController.todos.where((t) => t.status == 'pending').length})'),
                  selected: todoController.selectedStatus.value == 'pending',
                  onSelected: (selected) {
                    if (selected) todoController.setStatusFilter('pending');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('In Progress (${todoController.todos.where((t) => t.status == 'in-progress').length})'),
                  selected: todoController.selectedStatus.value == 'in-progress',
                  onSelected: (selected) {
                    if (selected) todoController.setStatusFilter('in-progress');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Completed (${todoController.todos.where((t) => t.status == 'completed').length})'),
                  selected: todoController.selectedStatus.value == 'completed',
                  onSelected: (selected) {
                    if (selected) todoController.setStatusFilter('completed');
                  },
                ),
              ],
            )),
          ),

          // Todo list
          Expanded(
            child: const TodoListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    Get.dialog(
      AddTodoDialog(),
      barrierDismissible: false,
    );
  }
}