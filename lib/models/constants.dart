import 'package:flutter/material.dart';
import 'package:quick_usb/quick_usb.dart';

/// Copied constants from https://github.com/petryx/avell-a52-lights/blob/master/avell_a52/driver/utils.py

class UsbConfig {
  static const vendorId = 0x048d; // 1165 in decimal
  static const productId = 0xce00; // 52736 in decimal
  static const bmRequestType = 0x21;
  static const bRequest = 0x09;
  static const wValue = 0x300;
  static const wIndex = 1;
}

const githubRepo = 'https://github.com/gabrc52/maingear-keyboard-lights/';

final usbDevice = UsbDevice(
  vendorId: UsbConfig.vendorId,
  productId: UsbConfig.productId,

  /// These two other parameters weren't listed in the original script
  /// I'm not sure what they are, and I'm not sure if they vary.
  identifier: '4',
  configurationCount: 1,
);

class MaingearColors {
  static const aqua = Color(0xff00ffff);
  static const blue = Color(0xff0000ff);
  static const fuchsia = Color(0xffff00ff);
  static const green = Color(0xff00ff00);
  static const gray = Color(0xff808080);
  static const lime = Color(0xff008000);
  static const maroon = Color(0xff800000);
  static const navy = Color(0xff000080);
  static const olive = Color(0xff808000);
  static const purple = Color(0xff800080);
  static const red = Color(0xffff0000);
  static const silver = Color(0xffc0c0c0);
  static const teal = Color(0xff008080);
  static const white = Color(0xffffffff);
  static const yellow = Color(0xffffff00);
  static const orange = Color(0xffff8000);
  static const black = Color(0xff000000);

  static const allColors = [
    MaingearColors.white,
    MaingearColors.silver,
    MaingearColors.maroon,
    MaingearColors.red,
    MaingearColors.orange,
    MaingearColors.olive,
    MaingearColors.yellow,
    MaingearColors.green,
    MaingearColors.lime,
    MaingearColors.teal,
    MaingearColors.aqua,
    MaingearColors.blue,
    MaingearColors.navy,
    MaingearColors.fuchsia,
    MaingearColors.purple,
    MaingearColors.black,
  ];
}

class KeyboardBrightness {
  static const b0 = 0x00;
  static const b1 = 0x08;
  static const b2 = 0x16;
  static const b3 = 0x24;
  static const b4 = 0x32;
  static const min = 0;
  static const max = 50;
}

class Directions {
  static const leftToRight = 0x01;
  static const rightToLeft = 0x02;

  /// Not sure what this is supposed to mean?
  static const sync = 0x03;
}

class Speed {
  static const min = 1;
  static const max = 10;
}
