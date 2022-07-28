import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'app.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ColorAdapter()); // to be able to save colors
  await Hive.openBox('rgb-kbd-config');
  await Hive.openBox<List<Color>>('rgb-kbd-config-colors');
  runApp(const App());
}
