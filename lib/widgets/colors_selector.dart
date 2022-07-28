import 'package:flutter/material.dart';

class ColorsSelector extends StatelessWidget {
  final int numColors;
  final List<Color> colors;

  const ColorsSelector(
      {Key? key, required this.numColors, required this.colors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(colors.length == numColors);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 32,
      ),
      child: Row(
        children: [
          const Text('Choose colors:'),
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
                onPressed: () {},
                child: const SizedBox(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
