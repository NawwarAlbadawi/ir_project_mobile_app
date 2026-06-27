import 'package:dio/dio.dart';
import 'package:ir_mobile_app/widgets/dio_interceptor/src/utils/extensions/request_extensions.dart';
import 'package:ir_mobile_app/widgets/dio_interceptor/src/utils/extensions/response_extensions.dart';
import '../enums/fancy_dio_key.dart';
extension DioErrorExtensions on DioException {
  String createUrlComponent() {
    return requestOptions.createUrlComponent();
  }
  String createRequestComponent() {
    return requestOptions.createRequestBody();
  }
  String createMethodComponent() {
    return requestOptions.createMethodComponent();
  }
  String createErrorComponent() {
    return response?.createResponseComponent() ?? response.toString();
  }
  String createResponseHeadersComponent() {
    return response?.createResponseHeadersComponent() ?? response.toString();
  }
  String createStatusCodeComponent() {
    return response?.statusCode.toString() ?? response.toString();
  }
  String get cURL => requestOptions.cURL;
  Duration calculateElapsedDuration() {
    final requestTime =
        requestOptions.extra[FancyDioKey.requestTime.key] as DateTime;
    final now = DateTime.now();
    return now.difference(requestTime);
  }
}