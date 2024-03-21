import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/constants/languages.dart';
import 'package:timetable/provider/language.dart';

/// app theme options drop-down menu.
class LanguageOptions extends StatelessWidget {
  final LanguageNotifier language;

  const LanguageOptions({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    String getLanguageLabel(Locale language) {
      const en = Locale('en', 'US');
      const fr = Locale('fr', 'FR');

      switch (language) {
        case en:
          return 'English';
        case fr:
          return 'Français';
        default:
          return 'English';
      }
    }

    List<DropdownMenuEntry<Locale>> themeEntries() {
      final themeEntries = <DropdownMenuEntry<Locale>>[];

      for (final Locale option in languages) {
        themeEntries.add(
          DropdownMenuEntry<Locale>(
            value: option,
            label: getLanguageLabel(option),
          ),
        );
      }
      return themeEntries.toList();
    }

    return Row(
      children: [
        const Text('language').tr(),
        const Spacer(),
        DropdownMenu<Locale>(
          width: 130,
          dropdownMenuEntries: themeEntries(),
          label: const Text("language").tr(),
          initialSelection: language.getLanguage(),
          onSelected: (value) {
            language.changeLanguage(value!);
            context.setLocale(value);
            // https://github.com/aissat/easy_localization/issues/370
            // https://github.com/aissat/easy_localization/issues/370#issuecomment-1312480842
            // couldn't find any other solution but reloading the app when changing the language
            // maybe an issue from easy localization itself (?)

            final engine = WidgetsFlutterBinding.ensureInitialized();
            engine.performReassemble();
          },
        ),
      ],
    );
  }
}
