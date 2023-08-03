import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/database/sqllite_adm_connection.dart';
import 'package:todo_list_provider/app/modules/auth/auth_module.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_controller.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_page.dart';
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
      initialRoute: '/login',
      routes: {
        ...AuthModule().routers,
      },
      home: SplashPage(),
    );
  }
}
