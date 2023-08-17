import 'package:flutter/material.dart';

class TodoListUiConfig {
  TodoListUiConfig._();

  static ThemeData get theme => ThemeData(
        // textTheme: GoogleFonts.mandaliTextTheme(),
        primaryColor: Color(0xFF5c77ce),
        primaryColorLight: Color(0xFFabc8f7),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5c77ce)),
        ),
      );
}
