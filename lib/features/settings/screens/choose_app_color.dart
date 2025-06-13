import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/shared/widgets/color_indicator.dart';
import 'package:timetable/shared/widgets/list_item_group.dart';
import 'package:timetable/core/constants/colors.dart';
import 'package:timetable/features/settings/providers/settings.dart';

/// allows the user to choose the app color found in the settings screen of the app.
class ChooseAppColor extends ConsumerWidget {
  const ChooseAppColor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeColor = ref.watch(settingsProvider).appThemeColor;
    final settings = ref.watch(settingsProvider.notifier);
    final colors = AppColorsList.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('choose_app_color').tr()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListItemGroup(
            children: List.generate(
              colors.length,
              (i) {
                return ListItem(
                  title: Row(
                    children: [
                      buildCheckmark(
                        appThemeColor: appThemeColor,
                        color: colors[i].color,
                      ),
                      ColorIndicator(color: colors[i].color),
                      const SizedBox(width: 16),
                      Text(colors[i].label).tr(),
                    ],
                  ),
                  onTap: () => settings.updateAppThemeColor(colors[i].color),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCheckmark({required Color appThemeColor, required Color color}) {
    return Visibility(
      visible: appThemeColor == color,
      child: const Row(
        children: [Icon(Icons.check, size: 18), SizedBox(width: 16)],
      ),
    );
  }
}
