import 'package:flutter/material.dart';
import 'package:maingear_keyboard_lights/models/app_state.dart';
import 'package:maingear_keyboard_lights/models/constants.dart';
// import 'package:maingear_keyboard_lights/models/light_control.dart';
// import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maingear_keyboard_lights/widgets/brightness_control.dart';
import 'package:maingear_keyboard_lights/widgets/colors_selector.dart';
import 'package:maingear_keyboard_lights/widgets/navigation_bar.dart';
import 'package:maingear_keyboard_lights/widgets/speed_control.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        TextButton.icon(
          icon: const Icon(Icons.info_outline),
          label: const Text('About'),
          onPressed: () async {
            showAboutDialog(
              context: context,
              applicationVersion: 'Control RGB keyboard lights',
              applicationIcon: const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.keyboard_alt_outlined),
              ),
              children: [
                const Text('App made by @gabrc52 based on code by @petryx'),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    launchUrl(Uri.parse(githubRepo));
                  },
                  icon: const FaIcon(FontAwesomeIcons.github),
                  label: const Text('View GitHub repo'),
                ),
              ],
            );
          },
        )
      ],
      body: Consumer<AppState>(
        builder: (context, state, _) => Column(
          children: [
            const AppNavigationBar(),
            const Divider(),
            if (state.keyboardMode != KeyboardMode.multiColor &&
                state.keyboardMode != KeyboardMode.singleColor) ...const [
              SpeedControl(),
              Divider()
            ],
            const BrightnessControl(),
            const Divider(),
            const ColorsSelector(),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
