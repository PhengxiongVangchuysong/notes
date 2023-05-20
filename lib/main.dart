import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:special_notes/pages/home_page.dart';
import 'package:special_notes/services/local_database_service.dart';
import 'package:special_notes/services/notification_service.dart';

void main() async {
  await LocalDatabaseService.instance.initialize();
  final localNotification = FlutterLocalNotificationsPlugin();

  // inject FlutterLocalNotificationsPlugin and set up notification service
  await NotificationService.instance.setup(localNotification);
  runApp(const SpecialNoteApp());
}

class SpecialNoteApp extends StatelessWidget {
  const SpecialNoteApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpecialNotesApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'SpecialNotesApp'),
    );
  }
}
