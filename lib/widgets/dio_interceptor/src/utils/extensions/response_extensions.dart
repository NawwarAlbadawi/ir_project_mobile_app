import 'package:dio/dio.dart';
import 'package:ir_mobile_app/widgets/dio_interceptor/src/utils/extensions/request_extensions.dart';
import '../enums/fancy_dio_key.dart';
import 'header_extensions.dart';
import 'map_extensions.dart';

extension ResponseExtensions on Response<dynamic> {
  String createUrlComponent() {
    return realUri.toString();
  }

  String createRequestComponent() {
    return requestOptions.createRequestBody();
  }

  String createMethodComponent() {
    return requestOptions.createMethodComponent();
  }

  String createResponseComponent() {
    final String body;

    if (data is Map<String, dynamic>) {
      body = (data as Map<String, dynamic>).toPrettyJson();
    } else {
      body = data.toString();
    }

    return body;
  }

  String createStatusCodeComponent() {
    return statusCode.toString();
  }

  String createResponseHeadersComponent() {
    return headers.createResponseHeaderComponent();
  }

  String get cURL => requestOptions.cURL;

  Duration calculateElapsedDuration() {
    final requestTime =
        requestOptions.extra[FancyDioKey.requestTime.key] as DateTime;
    final now = DateTime.now();

    return now.difference(requestTime);
  }
}
