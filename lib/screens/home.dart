import 'package:flutter/material.dart';
import 'package:maingear_keyboard_lights/models/constants.dart';
// import 'package:maingear_keyboard_lights/models/light_control.dart';
// import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maingear_keyboard_lights/widgets/colors_selector.dart';
import 'package:url_launcher/url_launcher.dart';

enum KeyboardMode { singleColor, multiColor, wave, breathing, flash, mix }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 1;
  KeyboardMode get keyboardMode => KeyboardMode.values[selectedIndex];

  double brightness = 25;

  int getNumColors() {
    if (keyboardMode == KeyboardMode.singleColor) {
      return 1;
    } else if (keyboardMode == KeyboardMode.multiColor) {
      return 4;
    } else {
      return 7;
    }
  }

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
                  icon: const Icon(FontAwesomeIcons.github),
                  label: const Text('View GitHub repo'),
                ),
              ],
            );
          },
        )
      ],
      body: Column(
        children: [
          BottomNavigationBar(
            currentIndex: selectedIndex,

            /// Manually override colors to workaround https://github.com/flutter/flutter/issues/108484
            selectedItemColor: const Color(0xffe2c1a4),
            selectedLabelStyle: const TextStyle(color: Color(0xffe2c1a4)),
            unselectedItemColor: const Color(0xffbcbbba),
            unselectedLabelStyle: const TextStyle(color: Color(0xffbcbbba)),
            showUnselectedLabels: true,
            onTap: (int val) {
              setState(() {
                selectedIndex = val;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.looks_one_outlined),
                label: 'Single color',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.color_lens_outlined),
                label: 'Multi color',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.waves_outlined),
                label: 'Wave',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.hurricane),
                label: 'Breathing',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flash_on),
                label: 'Flash',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.mix),
                label: 'Mix',
              ),
            ],
          ),
          const Divider(),
          Padding(
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
                    value: brightness,
                    onChanged: (val) {
                      setState(() {
                        brightness = val;
                      });
                    },
                    min: 0,
                    max: 50,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ColorsSelector(
            numColors: getNumColors(),
            colors: const [
              Colors.red,
              Colors.green,
              Colors.blue,
              Colors.purple,
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
