// credits go to https://looks.wtf/
const List<String> errorEmoticons = [
  "(╯°□°)╯︵ ┻━┻",
  "(；￣Д￣）",
  "(◔_◔)",
  "ʘ︵ʘ",
  "¯\\_(ツ)_/¯",
  "ಠ_ಠ",
  "( ͡ಠ ʖ̯ ͡ಠ)",
  "ಠ⌣ಠ",
  "( ͡° _ʖ ͡°)",
  "(•_•)",
  "┌─┐\n┴─┴\nಠ_ರೃ",
];

String getRandomErrorEmoticon() {
  final randomErrorEmoticon = (errorEmoticons.toList()..shuffle()).first;
  return randomErrorEmoticon;
}
