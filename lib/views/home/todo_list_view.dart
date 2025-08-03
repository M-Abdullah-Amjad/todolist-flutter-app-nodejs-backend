import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../controllers/todo_controller.dart';
import '../widgets/todo_card.dart';
import '../widgets/add_todo_dialog.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.find<TodoController>();

    return Obx(() {
      if (todoController.isLoading.value && todoController.todos.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Loading your todos...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      if (todoController.filteredTodos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  todoController.selectedStatus.value == 'all'
                      ? Icons.task_alt
                      : Icons.filter_list,
                  size: 80,
                  color: Colors.grey
              ),
              const SizedBox(height: 16),
              Text(
                todoController.selectedStatus.value == 'all'
                    ? 'No todos found'
                    : 'No ${todoController.selectedStatus.value} todos',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              Text(
                todoController.selectedStatus.value == 'all'
                    ? 'Add a new todo to get started!'
                    : 'Try creating a todo with this status',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (todoController.selectedStatus.value != 'all') ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => todoController.setStatusFilter('all'),
                  child: const Text('View All Todos'),
                ),
              ],
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => todoController.loadTodos(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: todoController.filteredTodos.length,
          itemBuilder: (context, index) {
            final todo = todoController.filteredTodos[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => _showEditTodoDialog(context, todo),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) => _deleteTodo(todo.id),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: TodoCard(todo: todo),
              ),
            );
          },
        ),
      );
    });
  }

  void _showEditTodoDialog(BuildContext context, todo) {
    Get.dialog(
      AddTodoDialog(todo: todo),
      barrierDismissible: false,
    );
  }

  void _deleteTodo(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.find<TodoController>().deleteTodo(id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}