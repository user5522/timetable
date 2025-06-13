import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/app.dart';
import 'package:timetable/core/constants/languages.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableLevels = [];

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: languages,
        path: 'assets/translations',
        fallbackLocale: languages[0],
        child: const TimetableApp(),
      ),
    ),
  );
}
