import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter/cupertino.dart';
import 'package:maingear_keyboard_lights/models/constants.dart';
import 'package:quick_usb/quick_usb.dart';
import 'package:libusb/libusb64.dart';
import 'package:flutter/material.dart';

class KeyboardLightControl extends ChangeNotifier {
  /// From quick_usb_desktop.dart
  Libusb _getLibusb() {
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
  Future<void> sendCommands(List<List<int>> commands) async {
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

      assert(result == command.length, 'Failed to send command to keyboard');
    }

    /// Close device and exit libusb
    libusb.libusb_close(devicePtr);
    libusb.libusb_exit(nullptr);
  }

  Future<dynamic> test() async {
    return await sendCommands([
      [8, 2, 1, 5, 50, 8, 0, 0],
    ]);
  }
}
