import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/todo_controller.dart';
import '../../models/todo_model.dart';

class AddTodoDialog extends StatefulWidget {
  final Todo? todo; // If provided, we're editing

  const AddTodoDialog({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedStatus = 'pending';

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      titleController.text = widget.todo!.title;
      descriptionController.text = widget.todo!.description;
      selectedStatus = widget.todo!.status;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.find<TodoController>();
    final bool isEditing = widget.todo != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Todo' : 'Add New Todo'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'in-progress', child: Text('In Progress')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        Obx(() => ElevatedButton(
          onPressed: todoController.isLoading.value
              ? null
              : () async {
            if (titleController.text.isEmpty) {
              Get.snackbar(
                'Error',
                'Title is required',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            bool success;
            if (isEditing) {
              success = await todoController.updateTodo(
                widget.todo!.id,
                titleController.text,
                descriptionController.text,
                selectedStatus,
              );
            } else {
              success = await todoController.createTodo(
                titleController.text,
                descriptionController.text,
                selectedStatus,
              );
            }

            if (success) {
              Get.back();
            }
          },
          child: todoController.isLoading.value
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Text(isEditing ? 'Update' : 'Add'),
        )),
      ],
    );
  }
}