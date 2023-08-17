import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';

class TodoCardFilter extends StatelessWidget {
  const TodoCardFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
          minHeight: 120,
          maxWidth: 150,
        ),
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.primaryColor,
          border: Border.all(
            width: 1,
            color: Colors.grey.withOpacity(.8),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '10 tasks',
              style: context.titleStyle.copyWith(
                // fontSize: 17,
                fontSize: 17,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            Text(
              'Hoje',
              style: TextStyle(
                // fontSize: 20,
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            LinearProgressIndicator(
              backgroundColor: context.primaryColorLight,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              value: 0.4,
            ),
          ],
        ));
  }
}
