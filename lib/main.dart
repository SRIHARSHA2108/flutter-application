import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/data/user_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserDatabase.instance.database;
  runApp(const GandaberundaApp());
}
