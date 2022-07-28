import 'package:adwaita/adwaita.dart';
import 'package:flutter/material.dart';
import 'package:maingear_keyboard_lights/models/app_state.dart';
import 'package:maingear_keyboard_lights/screens/home.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Keyboard lights',
          home: const HomePage(),
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.orange,
              brightness: Brightness.dark,
              background: AdwaitaColors.darkBackgroundColor,
            ),
            useMaterial3: true,
          ),
        );
      },
      child: const HomePage(),
    );
  }
}
