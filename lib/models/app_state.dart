import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maingear_keyboard_lights/models/light_control.dart';

import 'constants.dart';

enum KeyboardMode { singleColor, multiColor, wave, flash, breathing, mix }

enum ColorMode { custom, classic, material }

class AppState extends ChangeNotifier {
  final box = Hive.box('rgb-kbd-config');

  Future<void> turnOn() async {
    applyKeyboardMode();
    LightControl.setColors(colors);
  }

  Future<void> applyKeyboardMode() async {
    switch (mode) {
      case KeyboardMode.singleColor:
      case KeyboardMode.multiColor:
        await LightControl.multiColor(
            speed: speed, brightness: brightness, direction: direction);
        break;
      case KeyboardMode.wave:
        await LightControl.wave(
            speed: speed, brightness: brightness, direction: direction);
        break;
      case KeyboardMode.breathing:
        await LightControl.breathing(
            speed: speed, brightness: brightness, direction: direction);
        break;
      case KeyboardMode.flash:
        await LightControl.flash(
            speed: speed, brightness: brightness, direction: direction);
        break;
      case KeyboardMode.mix:
        await LightControl.mix(
            speed: speed, brightness: brightness, direction: direction);
        break;
    }
  }

  int get selectedIndex => box.get('selectedIndex', defaultValue: 1);
  set selectedIndex(int val) {
    box.put('selectedIndex', val);
    notifyListeners();
    applyKeyboardMode();
    LightControl.setColors(colors);
  }

  KeyboardMode get mode => KeyboardMode.values[selectedIndex];

  double get brightness => box.get('brightness', defaultValue: 25.0);
  set brightness(double val) {
    box.put('brightness', val);
    notifyListeners();
    applyKeyboardMode();
  }

  int get speed => box.get('speed', defaultValue: 7);
  set speed(int val) {
    box.put('speed', val);
    notifyListeners();
    applyKeyboardMode();
  }

  int get direction =>
      box.get('direction', defaultValue: Directions.leftToRight);

  set direction(int val) {
    box.put('direction', val);
    notifyListeners();
    applyKeyboardMode();
  }

  int getNumColors() {
    if (mode == KeyboardMode.singleColor) {
      return 1;
    } else if (mode == KeyboardMode.multiColor) {
      return 4;
    } else {
      return 7;
    }
  }

  List<Color> get colors {
    if (mode == KeyboardMode.singleColor) {
      return box.get('color')?.map<Color>((e) => Color(e)).toList() ??
          [Colors.green.shade500];
    } else if (mode == KeyboardMode.multiColor) {
      return box.get('4-colors')?.map<Color>((e) => Color(e)).toList() ??
          [
            Colors.red.shade500,
            Colors.green.shade500,
            Colors.blue.shade500,
            Colors.purple.shade500,
          ];
    } else {
      return box.get('7-colors')?.map<Color>((e) => Color(e)).toList() ??
          [
            Colors.red.shade500,
            Colors.orange.shade500,
            Colors.yellow.shade500,
            Colors.green.shade500,
            Colors.blue.shade500,
            Colors.indigo.shade500,
            Colors.purple.shade500,
          ];
    }
  }

  /// Saves colors to Hive. This doesn't update them in the keyboard
  set colors(List<Color> colors) {
    List<int> colorsInt = colors.map((e) => e.value).toList();
    assert(colors.length == getNumColors());
    if (mode == KeyboardMode.singleColor) {
      box.put('color', colorsInt);
    } else if (mode == KeyboardMode.multiColor) {
      box.put('4-colors', colorsInt);
    } else {
      box.put('7-colors', colorsInt);
    }
    notifyListeners();
  }

  Future<void> setColor(int index, Color value) async {
    LightControl.setColor(index, value);
    notifyListeners();
    var tmp = [...colors];
    tmp[index] = value;
    colors = tmp;
  }

  ColorMode get colorMode {
    int? modeInt = box.get('color-mode');
    if (modeInt == null) {
      return ColorMode.custom;
    } else {
      return ColorMode.values[modeInt];
    }
  }

  set colorMode(ColorMode val) {
    for (int i = 0; i < ColorMode.values.length; i++) {
      if (val == ColorMode.values[i]) {
        box.put('color-mode', i);
        notifyListeners();
        return;
      }
    }
  }

  /// whether to show shades of the colors in the material color picker
  bool get showMaterialShades =>
      box.get('show-material-shades', defaultValue: true);

  set showMaterialShades(bool val) {
    box.put('show-material-shades', val);
    notifyListeners();
  }
}
