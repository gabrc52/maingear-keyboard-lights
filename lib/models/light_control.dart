import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter/cupertino.dart';
import 'package:maingear_keyboard_lights/models/constants.dart';
import 'package:libusb/libusb64.dart';
import 'package:flutter/material.dart';

/// This class lets you control the keyboard lights - static methods only
class LightControl {
  LightControl._();

  /// From quick_usb_desktop.dart
  static Libusb _getLibusb() {
    if (Platform.isLinux) {
      // return Libusb(DynamicLibrary.open('/usr/lib/libusb-1.0.so')); // This gives a segfault
      return Libusb(DynamicLibrary.open(
          '${File(Platform.resolvedExecutable).parent.path}/lib/libusb-1.0.23.so'));
    } else if (Platform.isWindows) {
      return Libusb(DynamicLibrary.open('libusb-1.0.23.dll'));
    } else if (Platform.isMacOS) {
      return Libusb(DynamicLibrary.open('libusb-1.0.23.dylib'));
    }
    throw Exception('Platform is not supported');
  }

  // I swear the actual C code looks simpler than dart:ffi code - I've written it
  static Future<void> _sendCommands(List<List<int>> commands) async {
    // TODO: it would be best to extract initialization and deinitialization?
    // Libusb can still be static

    final libusb = _getLibusb();

    /// Init libusb
    libusb.libusb_init(nullptr);

    /// Open device
    final devicePtr = libusb.libusb_open_device_with_vid_pid(
        nullptr, UsbConfig.vendorId, UsbConfig.productId);
    assert(devicePtr != nullptr, 'Could not open device');

    /// Detach kernel driver. This is done in the Python script
    if (Platform.isLinux) {
      libusb.libusb_set_auto_detach_kernel_driver(devicePtr, 1);
    }

    for (var command in commands) {
      /// Convert List<int> to C type data - copied from quick_usb
      Uint8List data = Uint8List.fromList(command);
      final dataPtr = ffi.calloc<Uint8>(data.length);
      dataPtr.asTypedList(data.length).setAll(0, data);

      /// Send the command
      final result = libusb.libusb_control_transfer(
        devicePtr,
        UsbConfig.bmRequestType,
        UsbConfig.bRequest,
        UsbConfig.wValue,
        UsbConfig.wIndex,
        dataPtr,
        command.length,
        0, // unlimited timeout
      );

      assert(result == command.length,
          'Failed to send command to keyboard: $result');
    }

    /// Close device and exit libusb
    libusb.libusb_close(devicePtr);
    libusb.libusb_exit(nullptr);
  }

  static Future<void> _sendCommand(List<int> command) async {
    await _sendCommands([command]);
  }

  static Future<void> turnOff({bool save = true}) async {
    await _sendCommand([0x08, 0x01, 0x0, 0x0, 0x0, 0x0, 0x0, save ? 1 : 0]);
  }

  // TODO: Is it actually exact tho? switch to the discrete levels in the code if not
  static Future<void> setExactBrightness(num brightness,
      {bool save = true}) async {
    int brightnessInt = brightness.round().toInt();
    await _sendCommand(
        [0x08, 0x02, 0x01, 0x05, brightnessInt, 0x08, 0x00, save ? 1 : 0]);
  }

  static Future<void> setColors(List<Color> colors, {bool save = true}) async {
    /// single color is just a hack for multi color 4 times repeated
    if (colors.length == 1) {
      colors = [colors.first, colors.first, colors.first, colors.first];
    }
    for (int i = 0; i < colors.length; i++) {
      var color = colors[i];
      await _sendCommand([
        0x14,
        0x00,
        i + 1,
        color.red,
        color.green,
        color.blue,
        0x00,
        save ? 1 : 0
      ]);
    }
  }

  static Future<void> _changeMode(int modeNumber,
      {required bool save,
      required int speed,
      required num brightness,
      required int direction}) async {
    int brightnessInt = brightness.round();
    // we're substracting because low = slow and high = fast
    // speed of 0 means it doesn't move which is not what we want so we add 1
    int speedInt = Speed.max - speed + 1;
    await _sendCommand([
      0x08,
      0x02,
      modeNumber,
      speedInt,
      brightnessInt,
      0x08,
      direction,
      save ? 1 : 0,
    ]);
  }

  static Future<void> multiColor(
      {bool save = true,
      required int speed,
      required num brightness,
      required int direction}) async {
    await _changeMode(0x05,
        save: save, speed: speed, brightness: brightness, direction: direction);
  }

  static Future<void> wave(
      {bool save = true,
      required int speed,
      required num brightness,
      required int direction}) async {
    await _changeMode(0x03,
        save: save, speed: speed, brightness: brightness, direction: direction);
  }

  static Future<void> breathing(
      {bool save = true,
      required int speed,
      required num brightness,
      required int direction}) async {
    await _changeMode(0x02,
        save: save, speed: speed, brightness: brightness, direction: direction);
  }

  static Future<void> flash(
      {bool save = true,
      required int speed,
      required num brightness,
      required int direction}) async {
    await _changeMode(0x12,
        save: save, speed: speed, brightness: brightness, direction: direction);
  }

  static Future<void> mix(
      {bool save = true,
      required int speed,
      required num brightness,
      required int direction}) async {
    await _changeMode(0x13,
        save: save, speed: speed, brightness: brightness, direction: direction);
  }
}
