import 'package:flutter/material.dart';
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
                            // or Material, Block, MultipleChoiceBlock
                            child: ColorPicker(
                              pickerColor: state.colors[i],
                              onColorChanged: (val) => state.setColor(i, val),
                            ),
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
