import 'dart:async';
import 'package:flutter/services.dart';

const platform = MethodChannel('tk.user5522.timetable/androidVersion');

Future<int> getAndroidVersion() async {
  int version;

  try {
    final result = await platform.invokeMethod<int>('getAndroidVersion');
    version = result!;
  } on PlatformException {
    version = 0;
  }

  return version;
}
