import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_controller.dart';

class CalendarButton extends StatelessWidget {
  final dateFormat = DateFormat('dd/MM/y');

  CalendarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () async {
        var date = DateTime.now();
        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(date.year + 5, date.month, date.day),
        );

        context.read<TaskCreateController>().selectedDate = selectedDate;
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // * setar valor conforme conteúdo "fit-content"
          children: [
            Icon(Icons.today, color: Colors.grey),
            SizedBox(height: 10),
            Selector<TaskCreateController, DateTime?>(
              selector: (context, controller) => controller.selectedDate,
              builder: (context, selectedDate, child) {
                if (selectedDate != null) {
                  return Text(dateFormat.format(selectedDate), style: context.titleStyle.copyWith(fontSize: 15));
                } else {
                  return Text(
                    'Selecione uma data',
                    style: context.titleStyle.copyWith(fontSize: 15),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
