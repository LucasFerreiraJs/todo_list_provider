import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_provider/app/models/task_model.dart';

class Task extends StatelessWidget {
  final TaskModel taskModel;
  final dateFormat = DateFormat('dd/MM/y');

  Task({super.key, required this.taskModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: IntrinsicHeight(
        child: ListTile(
          contentPadding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(width: 1),
          ),
          leading: Checkbox(
            value: taskModel.finished,
            onChanged: (value) {
              print(value);
            },
          ),
          title: Text(
            taskModel.description,
            style: TextStyle(
              decoration: taskModel.finished ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            dateFormat.format(taskModel.dateTime),
            style: TextStyle(
              decoration: taskModel.finished ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }
}
