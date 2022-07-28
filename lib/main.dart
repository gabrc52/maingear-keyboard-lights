import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('config');
  var appDir = await getApplicationDocumentsDirectory();
  print(appDir);
  runApp(const App());
}
