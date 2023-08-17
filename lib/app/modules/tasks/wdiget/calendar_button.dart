import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';

class CalendarButton extends StatelessWidget {
  const CalendarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // setar valor conforme conteúdo "fit-content"
        children: [
          Icon(Icons.today, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'Selecione uma data',
            style: context.titleStyle.copyWith(fontSize: 15),
          )
        ],
      ),
    );
  }
}
