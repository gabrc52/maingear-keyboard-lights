import 'package:flutter/material.dart';
import 'package:maingear_keyboard_lights/models/light_control.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keyboard lights'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Test button'),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final controller =
                    Provider.of<KeyboardLightControl>(context, listen: false);
                final result = await controller.test();
                messenger.showMaterialBanner(
                  MaterialBanner(
                    content: Text('$result'),
                    actions: [
                      TextButton(
                        child: const Text('Dismiss'),
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
