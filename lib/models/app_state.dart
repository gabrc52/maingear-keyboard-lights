import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maingear_keyboard_lights/models/light_control.dart';

enum KeyboardMode { singleColor, multiColor, wave, breathing, flash, mix }

class AppState extends ChangeNotifier {
  final box = Hive.box('rgb-kbd-config');
  final colorBox = Hive.box<List<Color>>('rgb-kbd-config-colors');

  Future<void> applyKeyboardMode() async {
    LightControl.setColors(colors);
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

  /// TODO: implement changing direction
  int direction = 1;

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
      return colorBox.get('color', defaultValue: [Colors.green.shade500])!;
    } else if (mode == KeyboardMode.multiColor) {
      return colorBox.get('4-colors', defaultValue: [
        Colors.red.shade500,
        Colors.green.shade500,
        Colors.blue.shade500,
        Colors.purple.shade500,
      ])!;
    } else {
      return colorBox.get('7-colors', defaultValue: [
        Colors.red.shade500,
        Colors.orange.shade500,
        Colors.yellow.shade500,
        Colors.green.shade500,
        Colors.blue.shade500,
        Colors.indigo.shade500,
        Colors.purple.shade500,
      ])!;
    }
  }

  /// TODO: actually send command
  set colors(List<Color> colors) {
    assert(colors.length == getNumColors());
    if (mode == KeyboardMode.singleColor) {
      colorBox.put('color', colors);
    } else if (mode == KeyboardMode.multiColor) {
      colorBox.put('4-colors', colors);
    } else {
      colorBox.put('7-colors', colors);
    }
    notifyListeners();
    LightControl.setColors(colors);
  }

  Future<void> setColor(int index, Color value) async {
    LightControl.setColor(index, value);
    notifyListeners();
    var tmp = [...colors];
    tmp[index] = value;
    colors = tmp;
  }
}
