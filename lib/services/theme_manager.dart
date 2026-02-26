import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  String _themeMode = "Neo Dark";
  String get currentThemeName => _themeMode;

  ThemeData get currentTheme {
    switch (_themeMode) {
      case "Light Mode":
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          cardColor: Colors.white,
          dividerColor: Colors.black12,
          hintColor: Colors.black38,
          iconTheme: const IconThemeData(color: Colors.black54),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF1E293B)),
            bodyMedium: TextStyle(color: Color(0xFF475569)),
            titleLarge: TextStyle(color: Color(0xFF0F172A)),
          ),
        );
      case "Amoled":
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.black,
          cardColor: const Color(0xFF121212),
          dividerColor: Colors.white10,
          hintColor: Colors.white38,
          iconTheme: const IconThemeData(color: Colors.white54),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            titleLarge: TextStyle(color: Colors.white),
          ),
        );
      case "Neo Dark":
      default:
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: Colors.blue.shade600,
          scaffoldBackgroundColor: const Color(0xFF0F172A),
          cardColor: const Color(0xFF1E293B),
          dividerColor: Colors.white.withAlpha(10),
          hintColor: Colors.white38,
          iconTheme: const IconThemeData(color: Colors.white54),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            titleLarge: TextStyle(color: Colors.white),
          ),
        );
    }
  }

  void setTheme(String themeName) {
    _themeMode = themeName;
    notifyListeners();
  }
}
