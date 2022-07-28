import 'package:flutter/material.dart';
import 'package:maingear_keyboard_lights/models/app_state.dart';
import 'package:provider/provider.dart';

class BrightnessControl extends StatelessWidget {
  const BrightnessControl({
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
            const Text('Brightness:'),
            const SizedBox(width: 32),
            Expanded(
              child: Slider(
                value: state.brightness,
                onChanged: (val) => state.brightness = val,
                min: 0,
                max: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
