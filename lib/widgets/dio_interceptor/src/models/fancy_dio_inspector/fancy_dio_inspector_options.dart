import 'fancy_dio_inspector_console_options.dart';


class FancyDioInspectorOptions {
  
  final bool logRequests;

  
  final bool logResponses;

  
  final bool logErrors;

  
  final int maxLogs;

  
  final FancyDioInspectorConsoleOptions consoleOptions;

  const FancyDioInspectorOptions({
    this.logRequests = true,
    this.logResponses = true,
    this.logErrors = true,
    this.maxLogs = 50,
    this.consoleOptions = const FancyDioInspectorConsoleOptions(),
  });
}
