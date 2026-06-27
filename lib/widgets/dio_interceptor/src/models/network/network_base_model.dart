import '../../utils/helpers/clipboard_helper.dart';
abstract class NetworkBaseModel {
  final String url;
  final String method;
  final String requestBody;
  final String headers;
  final String cURL;
  final DateTime time;
  const NetworkBaseModel({
    required this.url,
    required this.method,
    required this.requestBody,
    required this.headers,
    required this.cURL,
    required this.time,
  });
  bool contains(String query);
  String toClipboardText() => ClipboardHelper.createClipboardText(this);
}