import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maingear_keyboard_lights/models/constants.dart';
import 'package:maingear_keyboard_lights/models/light_control.dart';

enum KeyboardMode { singleColor, multiColor, wave, breathing, flash, mix }

class AppState extends ChangeNotifier {
  final box = Hive.box('config');

  Future<void> applyKeyboardMode() async {
    switch (keyboardMode) {
      case KeyboardMode.singleColor:
      case KeyboardMode.multiColor:
        await KeyboardLightControl.multiColor(
            speed: speed, brightness: brightness, direction: direction);
        break;
      case KeyboardMode.wave:
        await KeyboardLightControl.wave(
            speed: speed, brightness: brightness, direction: direction);
        break;
      case KeyboardMode.breathing:
        await KeyboardLightControl.breathing(
            speed: speed, brightness: brightness, direction: direction);
        break;
      case KeyboardMode.flash:
        await KeyboardLightControl.flash(
            speed: speed, brightness: brightness, direction: direction);
        break;
      case KeyboardMode.mix:
        await KeyboardLightControl.mix(
            speed: speed, brightness: brightness, direction: direction);
        break;
    }
  }

  int get selectedIndex => box.get('selectedIndex', defaultValue: 1);
  set selectedIndex(int val) {
    box.put('selectedIndex', val);
    notifyListeners();
    applyKeyboardMode();
  }

  KeyboardMode get keyboardMode => KeyboardMode.values[selectedIndex];

  double get brightness => box.get('brightness', defaultValue: 25.0);
  set brightness(double val) {
    box.put('brightness', val);
    notifyListeners();
    applyKeyboardMode();
  }

  /// TODO: implement changing speed
  int speed = 7;

  /// TODO: implement changing direction
  int direction = 1;

  int getNumColors() {
    if (keyboardMode == KeyboardMode.singleColor) {
      return 1;
    } else if (keyboardMode == KeyboardMode.multiColor) {
      return 4;
    } else {
      return 7;
    }
  }

  /// TODO: implement changing color(s)
  List<Color> get colors => [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple
      ].sublist(0, getNumColors());
}
