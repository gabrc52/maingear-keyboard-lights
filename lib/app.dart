import 'package:flutter/material.dart';
import 'package:maingear_keyboard_lights/models/light_control.dart';
import 'package:maingear_keyboard_lights/screens/home.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<KeyboardLightControl>(
      create: (context) => KeyboardLightControl(),
      builder: (context, child) {
        return MaterialApp(
          title: 'Keyboard lights',
          home: child,
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.orange,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
        );
      },
      child: const HomePage(),
    );
  }
}
