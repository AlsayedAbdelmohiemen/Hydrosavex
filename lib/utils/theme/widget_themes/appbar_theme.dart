import 'package:flutter/material.dart';


class SAppBarTheme{
  SAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor:  Colors.transparent,
    iconTheme: IconThemeData( color: Color(0xFF0C76B0),size: 27),
    actionsIconTheme: IconThemeData(color: Color(0xFF0C76B0),size: 27),
    titleTextStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 24,color: Color(0xFF0C76B0)),

  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor:  Colors.transparent,
    iconTheme: IconThemeData( color: Color(0xFF0C76B0),size: 27),
    actionsIconTheme: IconThemeData(color: Color(0xFF0C76B0),size: 27),
    titleTextStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 24,color: Color(0xFF0C76B0)),

  );
}