import '../../l10n/fancy_strings.dart';
class FancyDioInspectorL10nOptions {
  final String appBarText;
  final String requestsText;
  final String responsesText;
  final String errorsText;
  final String searchHintText;
  final String cURLText;
  final String copyText;
  final String copiedText;
  final String cURLCopiedText;
  final String urlTitleText;
  final String requestTitleText;
  final String headersTitleText;
  final String responseTitleText;
  final String errorTitleText;
  const FancyDioInspectorL10nOptions({
    this.appBarText = FancyStrings.appBarText,
    this.requestsText = FancyStrings.requests,
    this.responsesText = FancyStrings.responses,
    this.errorsText = FancyStrings.errors,
    this.searchHintText = FancyStrings.search,
    this.cURLText = FancyStrings.cURL,
    this.copyText = FancyStrings.copy,
    this.copiedText = FancyStrings.copied,
    this.cURLCopiedText = FancyStrings.cURLCopied,
    this.urlTitleText = FancyStrings.urlTitle,
    this.requestTitleText = FancyStrings.requestTitle,
    this.headersTitleText = FancyStrings.headersTitle,
    this.responseTitleText = FancyStrings.responseTitle,
    this.errorTitleText = FancyStrings.errorTitle,
  });
}