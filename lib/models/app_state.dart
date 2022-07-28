import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:maingear_keyboard_lights/models/light_control.dart';

enum KeyboardMode { singleColor, multiColor, wave, breathing, flash, mix }

class AppState extends ChangeNotifier {
  final box = Hive.box('config');

  int get selectedIndex => box.get('selectedIndex', defaultValue: 1);
  set selectedIndex(int val) {
    box.put('selectedIndex', val);
    notifyListeners();
  }

  KeyboardMode get keyboardMode => KeyboardMode.values[selectedIndex];

  double get brightness => box.get('brightness', defaultValue: 25.0);
  set brightness(double val) {
    box.put('brightness', val);
    notifyListeners();
    KeyboardLightControl.setExactBrightness(val);
  }

  int getNumColors() {
    if (keyboardMode == KeyboardMode.singleColor) {
      return 1;
    } else if (keyboardMode == KeyboardMode.multiColor) {
      return 4;
    } else {
      return 7;
    }
  }
}
