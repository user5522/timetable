import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/core/constants/languages.dart';
import 'package:timetable/core/utils/languages.dart';
import 'package:timetable/shared/providers/language.dart';

/// app language options dropdown menu.
class LanguageOptions extends StatelessWidget {
  final LanguageNotifier language;

  const LanguageOptions({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    /// The dropdown menu entries of each language.
    List<DropdownMenuEntry<Locale>> languageEntries() {
      final themeEntries = <DropdownMenuEntry<Locale>>[];

      for (final Locale option in languages) {
        final label = getLanguageLabel(option);

        themeEntries.add(
          DropdownMenuEntry<Locale>(value: option, label: label),
        );
      }
      return themeEntries.toList();
    }

    return Row(
      children: [
        const Text('language').tr(),
        const Spacer(),
        FutureBuilder(
          future: language.getLanguage(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            return DropdownMenu<Locale>(
              width: 130,
              dropdownMenuEntries: languageEntries(),
              label: const Text("language").tr(),
              initialSelection: snapshot.data,
              onSelected: (value) {
                language.changeLanguage(value!);
                context.setLocale(value);
                // https://github.com/aissat/easy_localization/issues/370
                // https://github.com/aissat/easy_localization/issues/370#issuecomment-1312480842
                // couldn't find any other solution but reassembling the app

                final engine = WidgetsFlutterBinding.ensureInitialized();
                engine.performReassemble();
              },
            );
          },
        ),
      ],
    );
  }
}
