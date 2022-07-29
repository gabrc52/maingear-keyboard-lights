import 'package:flutter/material.dart';
import 'package:maingear_keyboard_lights/models/app_state.dart';
import 'package:maingear_keyboard_lights/models/constants.dart';
import 'package:provider/provider.dart';

class DirectionControl extends StatelessWidget {
  const DirectionControl({Key? key}) : super(key: key);

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
              const Text('Choose direction:'),
              const Spacer(flex: 1),
              ChoiceChip(
                label: const Text('Left to right'),
                selected: state.direction == Directions.leftToRight,
                onSelected: (selected) {
                  if (selected) {
                    state.direction = Directions.leftToRight;
                  }
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Right to left'),
                selected: state.direction == Directions.rightToLeft,
                onSelected: (selected) {
                  if (selected) {
                    state.direction = Directions.rightToLeft;
                  }
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('None'),
                selected: state.direction == Directions.sync,
                onSelected: (selected) {
                  if (selected) {
                    state.direction = Directions.sync;
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
