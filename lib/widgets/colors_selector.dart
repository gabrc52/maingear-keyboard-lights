import 'package:adwaita/adwaita.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maingear_keyboard_lights/models/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../models/app_state.dart';

class ColorsSelector extends StatelessWidget {
  const ColorsSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final colors = state.colors;
        final numColors = state.getNumColors();
        assert(colors.length == numColors);
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 32,
          ),
          child: Row(
            children: [
              Text('Choose color${numColors == 1 ? '' : 's'}:'),
              const Spacer(flex: 1),
              for (var i = 0; i < colors.length; i++) ...[
                const SizedBox(width: 16),
                Tooltip(
                  message: 'Change color ${i + 1}',
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: colors[i],
                      //shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: ChoosableColorPicker(i: i),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: const SizedBox(),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class ChoosableColorPicker extends StatelessWidget {
  const ChoosableColorPicker({
    Key? key,
    required this.i,
  }) : super(key: key);

  final int i;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) => Column(
        children: [
          CupertinoSlidingSegmentedControl<ColorMode>(
            children: const {
              ColorMode.custom: Text('Custom'),
              ColorMode.classic: Text('Classic'),
              ColorMode.material: Text('Material'),
            },
            groupValue: state.colorMode,
            onValueChanged: (val) {
              if (val != null) {
                state.colorMode = val;
              }
            },
          ),
          const SizedBox(height: 16),
          if (state.colorMode == ColorMode.custom)
            ColorPicker(
              enableAlpha: false,
              hexInputBar: true,
              pickerColor: state.colors[i],
              onColorChanged: (val) => state.setColor(i, val),
            ),
          if (state.colorMode == ColorMode.classic)
            BlockPicker(
              pickerColor: state.colors[i],
              onColorChanged: (val) => state.setColor(i, val),
              availableColors: MaingearColors.allColors,
            ),
          if (state.colorMode == ColorMode.material) ...[
            SwitchListTile(
              title: const Text('Show shades'),
              value: state.showMaterialShades,
              onChanged: (val) => state.showMaterialShades = val,
            ),
            if (state.showMaterialShades)
              MaterialPicker(
                pickerColor: state.colors[i],
                onColorChanged: (val) => state.setColor(i, val),
                onPrimaryChanged: (val) => state.setColor(i, val),
                enableLabel: true,
              )
            else
              BlockPicker(
                pickerColor: state.colors[i],
                onColorChanged: (val) => state.setColor(i, val),
              ),
          ],
        ],
      ),
    );
  }
}
