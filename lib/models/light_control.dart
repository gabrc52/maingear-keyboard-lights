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

  /// Pasted from quick_usb_desktop.dart, because it's private
  String? _getStringDescriptorASCII(
      Libusb libusb, Pointer<libusb_device_handle> handle, int descIndex) {
    String? result;
    Pointer<ffi.Utf8> string = ffi.calloc<Uint8>(256).cast();
    try {
      var ret = libusb.libusb_get_string_descriptor_ascii(
          handle, descIndex, string.cast(), 256);
      if (ret > 0) {
        result = string.toDartString();
      }
    } finally {
      ffi.calloc.free(string);
    }
    return result;
  }

  // I swear the actual C code looks simpler than dart:ffi code - I've written it
  Future<dynamic> sendCommands(List<List<int>> commands) async {
    final libusb = _getLibusb();

    /// Init libusb
    libusb.libusb_init(nullptr);

    /// Open device
    final devicePtr = libusb.libusb_open_device_with_vid_pid(
        nullptr, UsbConfig.vendorId, UsbConfig.productId);
    assert(devicePtr != nullptr, 'Could not open device');

    /// Detach kernel driver. This is done in the Python script
    if (Platform.isLinux) {
      // final result = libusb.libusb_set_auto_detach_kernel_driver(devicePtr, 1);
      // print(result);
      if (libusb.libusb_kernel_driver_active(devicePtr, 1) == 1) {
        print(libusb.libusb_detach_kernel_driver(devicePtr, 1));
      }
    }

    // Get description?
    var descPtr = ffi.calloc<libusb_device_descriptor>();
    var device = libusb.libusb_get_device(devicePtr);
    print(libusb.libusb_get_device_descriptor(device, descPtr));
    var manufacturer =
        _getStringDescriptorASCII(libusb, devicePtr, descPtr.ref.iProduct);
    print(manufacturer);

    // print(libusb.libusb_claim_interface(devicePtr, 0));

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

      assert(result == command.length);
      print(result);
    }

    // print(libusb.libusb_release_interface(devicePtr, 0));

    /// Close device and exit libusb
    libusb.libusb_close(devicePtr);
    libusb.libusb_exit(nullptr);

    return manufacturer;
  }

  Future<dynamic> doThing() async {
    /// Close device if not closed
    try {
      await QuickUsb.closeDevice();
    } catch (e) {
      // No need to do anything
    }

    /// Initialization stuff
    await QuickUsb.init();
    if (!await QuickUsb.openDevice(usbDevice)) {
      throw Exception(
          "Couldn't find the device. You're either not using a supported laptop. If you are, please open a GitHub issue.");
    }
    await QuickUsb.setAutoDetachKernelDriver(true);
    final configuration = await QuickUsb.getConfiguration(0);
    // if (!await QuickUsb.claimInterface(configuration.interfaces[0])) {
    //   throw Exception('Unable to claim interface!');
    // }

    /// Cleanup
    // QuickUsb.releaseInterface(configuration.interfaces[1]);

    await QuickUsb.closeDevice();
    await QuickUsb.exit();

    return configuration;
  }

  Future<dynamic> test() async {
    return await sendCommands([
      [8, 2, 1, 5, 50, 8, 0, 0],
    ]);
  }
}
