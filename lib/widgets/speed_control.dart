import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maingear_keyboard_lights/models/app_state.dart';
import 'package:maingear_keyboard_lights/models/constants.dart';
import 'package:provider/provider.dart';

// Basically copy pasted from brightness_control.dart

class SpeedControl extends StatelessWidget {
  const SpeedControl({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 32,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 128,
              child: Text('Speed:'),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: const Icon(Icons.speed),
            ),
            Expanded(
              child: Slider(
                divisions: 9,
                label: '${state.speed}',
                value: state.speed.toDouble(),
                onChanged: (val) => state.speed = val.toInt(),
                min: Speed.min.toDouble(),
                max: Speed.max.toDouble(),
              ),
            ),
            const Icon(Icons.speed),
          ],
        ),
      ),
    );
  }
}
