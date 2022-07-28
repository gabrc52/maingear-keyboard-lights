import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('config');
  runApp(const App());
}
