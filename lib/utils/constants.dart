import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFFFFFFFFF); 
  static const card = Color(0xFFF2F2F2); 
  static const azura = Color(0xFFB38686); 
  static const selly = Color(0xFFD6ACAC);
  static const textPrimary = Colors.black;
  static const textSecondary = Color(0xFF7C7C7C); 
  static const border = Color(0xFFE0E0E0);
  static const inputFill = Color(0xFFFDFBFC);

  

  static final ThemeData theme = ThemeData(
    scaffoldBackgroundColor: background,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: azura,      
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,            
      titleSpacing: 0,            
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: azura,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: border),
      )
    )
  );
}


class AppText {
  static const appName = 'Enjoy Coffee';
  static const tagline = 'Grab a coffee, make life less bland';
}

