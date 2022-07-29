import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maingear_keyboard_lights/models/app_state.dart';
import 'package:provider/provider.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) => BottomNavigationBar(
        currentIndex: state.selectedIndex,

        /// Manually override colors to workaround https://github.com/flutter/flutter/issues/108484
        selectedItemColor: const Color(0xffe2c1a4),
        selectedLabelStyle: const TextStyle(color: Color(0xffe2c1a4)),
        unselectedItemColor: const Color(0xffbcbbba),
        unselectedLabelStyle: const TextStyle(color: Color(0xffbcbbba)),
        showUnselectedLabels: true,
        onTap: (int val) => state.selectedIndex = val,
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
            icon: Icon(Icons.flash_on),
            label: 'Flash',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.hurricane),
            label: 'Breathing',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.mix),
            label: 'Mix',
          ),
        ],
      ),
    );
  }
}
