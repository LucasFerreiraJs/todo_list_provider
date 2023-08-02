import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/database/sqllite_adm_connection.dart';
import 'package:todo_list_provider/app/modules/splash/splash_page.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final sqliAdmConnection = SqliteAdmConnection();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(sqliAdmConnection);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(sqliAdmConnection);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List Provider',
      home: SplashPage(),
    );
  }
}
