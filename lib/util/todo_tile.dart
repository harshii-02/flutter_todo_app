
import 'package:flutter/material.dart';



class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool?) onChanged;
  final Function()? onDelete;

  const ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(taskName),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete!();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task "$taskName" deleted')),
        );
      },
      child: ListTile(
        title: Text(
          taskName,
          style: TextStyle(
            decoration: taskCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        leading: Checkbox(
          value: taskCompleted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
