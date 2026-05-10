import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TextSize { small, medium, large }

extension TextSizeScale on TextSize {
  String get label => switch (this) {
        TextSize.small => 'Small',
        TextSize.medium => 'Medium',
        TextSize.large => 'Large',
      };

  /// Scale factor applied to the base lyrics font size (17px).
  double get scale => switch (this) {
        TextSize.small => 0.85,
        TextSize.medium => 1.0,
        TextSize.large => 1.2,
      };
}

const _textSizePrefKey = 'text_size';

class TextSizeNotifier extends Notifier<TextSize> {
  @override
  TextSize build() => TextSize.medium;

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_textSizePrefKey);
    state = switch (stored) {
      'small' => TextSize.small,
      'large' => TextSize.large,
      _ => TextSize.medium,
    };
  }

  Future<void> setSize(TextSize size) async {
    state = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_textSizePrefKey, size.name);
  }
}

final textSizeProvider = NotifierProvider<TextSizeNotifier, TextSize>(
  TextSizeNotifier.new,
);
