import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/constants/languages.dart';
import 'package:timetable/provider/language.dart';

/// app language options dropdown menu.
class LanguageOptions extends StatelessWidget {
  final LanguageNotifier language;

  const LanguageOptions({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    /// for each value of the enum it will give a corresponding label.
    // maybe this should be a function inside the List declaration file?
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

    /// The dropdown menu entries of each language.
    List<DropdownMenuEntry<Locale>> languageEntries() {
      final themeEntries = <DropdownMenuEntry<Locale>>[];

      for (final Locale option in languages) {
        final label = getLanguageLabel(option);

        themeEntries.add(
          DropdownMenuEntry<Locale>(
            value: option,
            label: label,
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
          dropdownMenuEntries: languageEntries(),
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
