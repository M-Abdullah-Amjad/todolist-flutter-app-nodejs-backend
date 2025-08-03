import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      description: json['description'] ?? '',
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get formattedCreatedAt {
    return DateFormat('MMM dd, yyyy').format(createdAt);
  }

  String get formattedUpdatedAt {
    return DateFormat('MMM dd, yyyy').format(updatedAt);
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in-progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}