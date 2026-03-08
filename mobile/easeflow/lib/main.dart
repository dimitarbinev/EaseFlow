// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/signup_page.dart';
import 'pages/home_page.dart';
import 'pages/child/child_home_page.dart';
import 'pages/child/child_tasks_page.dart';
import 'pages/create_task_page.dart';
import 'pages/manage_tasks_page.dart';
import 'pages/person_info_page.dart';
import 'pages/settings_page.dart';
import 'models/task_model.dart';

// 🧠 Global in-memory list (temporary until full backend)
final List<TaskModel> tasks = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 MUST be first
  await dotenv.load(fileName: ".env");

  // 🔥 THEN Firebase - only initialize if not already done
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString('theme_mode') ?? 'dark';
    setState(() {
      _themeMode = _getThemeModeFromString(themeName);
    });
  }

  ThemeMode _getThemeModeFromString(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }

  void _changeTheme(ThemeMode newTheme) async {
    setState(() {
      _themeMode = newTheme;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', newTheme.toString().split('.').last);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: _themeMode,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => SignupPage(),

        // 👨‍👩‍👧 Parent home
        '/': (context) => HomePage(),

        // 🧒 Child pages
        '/child-home': (context) => ChildHomePage(),
        '/child-tasks': (context) => const ChildTasksPage(),

        // 🧾 Task pages
        '/create-task': (context) => CreateTaskPage(tasks: tasks),
        '/manage-tasks': (context) => ManageTasksPage(),

        '/person-info': (context) => PersonInfoPage(),
        '/settings': (context) => SettingsPage(
          onThemeChanged: _changeTheme,
          currentTheme: _themeMode,
        ),
      },
    );
  }
}
