import '../../l10n/fancy_strings.dart';
import '../../utils/enums/fancy_console_colors.dart';
class FancyDioInspectorConsoleOptions {
  final bool verbose;
  final bool colorize;
  final String requestName;
  final String responseName;
  final String errorName;
  final FancyConsoleTextColors requestColor;
  final FancyConsoleTextColors responseColor;
  final FancyConsoleTextColors errorColor;
  const FancyDioInspectorConsoleOptions({
    this.verbose = false,
    this.colorize = true,
    this.requestName = FancyStrings.requestUpperCased,
    this.responseName = FancyStrings.responseUpperCased,
    this.errorName = FancyStrings.errorUpperCased,
    this.requestColor = FancyConsoleTextColors.yellow,
    this.responseColor = FancyConsoleTextColors.green,
    this.errorColor = FancyConsoleTextColors.red,
  });
}