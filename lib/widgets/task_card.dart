import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';


class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Checkbox(
          value: task.isDone,
          activeColor: Colors.green,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          task.matkul,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration:
                task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.deskripsi),
            const SizedBox(height: 4),
            Text(
              '🗓 ${dateFormat.format(task.deadline)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
