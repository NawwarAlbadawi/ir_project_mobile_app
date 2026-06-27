import 'package:dio/dio.dart';
abstract class NetworkErrorResult {
  final Object? errorBody;
  final int? statusCode;
  final String errMessage;
  const NetworkErrorResult({
    this.errorBody,
    this.statusCode,
    required this.errMessage,
  });
}
class NetworkError extends NetworkErrorResult {
  NetworkError({super.errorBody, super.statusCode, required super.errMessage});
  factory NetworkError.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkError(
          errorBody: dioError.response,
          errMessage: 'Connection Timed Out',
        );
      case DioExceptionType.sendTimeout:
        return NetworkError(
          errorBody: dioError.response,
          errMessage: 'Send Timed Out',
        );
      case DioExceptionType.receiveTimeout:
        return NetworkError(
          errorBody: dioError.response,
          errMessage: 'Receive Timed Out',
        );
      case DioExceptionType.badResponse:
        final response = dioError.response;
        if (response == null || response.statusCode == null) {
          return NetworkError(
            errorBody: null,
            errMessage: 'Bad response with no data',
          );
        }
        return NetworkError.fromBadResponse(
          response.statusCode!,
          response.data,
        );
      case DioExceptionType.cancel:
        return NetworkError(
          errorBody: dioError.response,
          errMessage: 'Request to ApiServer was canceled',
        );
      case DioExceptionType.unknown:
        if (dioError.message != null &&
            dioError.message!.contains('SocketException')) {
          return NetworkError(
            errorBody: dioError.response,
            errMessage: 'No Internet Connection',
          );
        }
        return NetworkError(
          errorBody: dioError.response,
          errMessage: 'Unexpected Error, Please try again!',
        );
      default:
        return NetworkError(
          errorBody: dioError.response,
          errMessage: 'Oops! There was an error, please try again',
        );
    }
  }
  factory NetworkError.fromBadResponse(int statusCode, dynamic response) {
    switch (statusCode) {
      case 400:
        return NetworkError(
          errorBody: response,
          statusCode: 400,
          errMessage: "The request couldn't be completed",
        );
      case 401:
        return NetworkError(
          errorBody: response,
          statusCode: 401,
          errMessage: 'Your session has expired. Please log in again.',
        );
      case 402:
        return NetworkError(
          errorBody: response,
          statusCode: 402,
          errMessage: 'Payment Required',
        );
      case 403:
        return NetworkError(
          errorBody: response,
          statusCode: 403,
          errMessage: 'Forbidden',
        );
      case 404:
        return NetworkError(
          errorBody: response,
          statusCode: 404,
          errMessage: 'Not Found',
        );
      case 405:
        return NetworkError(
          errorBody: response,
          statusCode: 405,
          errMessage: 'Method Not Allowed',
        );
      case 406:
        return NetworkError(
          errorBody: response,
          statusCode: 406,
          errMessage: 'Not Acceptable',
        );
      case 407:
        return NetworkError(
          errorBody: response,
          statusCode: 407,
          errMessage: 'Proxy Authentication Required',
        );
      case 408:
        return NetworkError(
          errorBody: response,
          statusCode: 408,
          errMessage: 'Request Timeout',
        );
      case 409:
        return NetworkError(
          errorBody: response,
          statusCode: 409,
          errMessage: "The request couldn't be completed",
        );
      case 410:
        return NetworkError(
          errorBody: response,
          statusCode: 410,
          errMessage: 'Gone',
        );
      case 411:
        return NetworkError(
          errorBody: response,
          statusCode: 411,
          errMessage: 'Length Required',
        );
      case 412:
        return NetworkError(
          errorBody: response,
          statusCode: 412,
          errMessage: 'Precondition Failed',
        );
      case 413:
        return NetworkError(
          errorBody: response,
          statusCode: 413,
          errMessage: 'Payload Too Large',
        );
      case 414:
        return NetworkError(
          errorBody: response,
          statusCode: 414,
          errMessage: 'URI Too Long',
        );
      case 415:
        return NetworkError(
          errorBody: response,
          statusCode: 415,
          errMessage: 'Unsupported Media Type',
        );
      case 416:
        return NetworkError(
          errorBody: response,
          statusCode: 416,
          errMessage: 'Range Not Satisfiable',
        );
      case 417:
        return NetworkError(
          errorBody: response,
          statusCode: 417,
          errMessage: 'Expectation Failed',
        );
      case 418:
        return NetworkError(
          errorBody: response,
          statusCode: 418,
          errMessage: "I'm a teapot",
        );
      case 421:
        return NetworkError(
          errorBody: response,
          statusCode: 421,
          errMessage: 'Misdirected Request',
        );
      case 422:
        return NetworkError(
          errorBody: response,
          statusCode: 422,
          errMessage: 'Unprocessable Content',
        );
      case 423:
        return NetworkError(
          errorBody: response,
          statusCode: 423,
          errMessage: 'Locked',
        );
      case 424:
        return NetworkError(
          errorBody: response,
          statusCode: 424,
          errMessage: 'Failed Dependency',
        );
      case 425:
        return NetworkError(
          errorBody: response,
          statusCode: 425,
          errMessage: 'Too Early',
        );
      case 426:
        return NetworkError(
          errorBody: response,
          statusCode: 426,
          errMessage: 'Upgrade Required',
        );
      case 428:
        return NetworkError(
          errorBody: response,
          statusCode: 428,
          errMessage: 'Precondition Required',
        );
      case 429:
        return NetworkError(
          errorBody: response,
          statusCode: 429,
          errMessage: 'Too Many Requests',
        );
      case 431:
        return NetworkError(
          errorBody: response,
          statusCode: 431,
          errMessage: 'Request Header Fields Too Large',
        );
      case 451:
        return NetworkError(
          errorBody: response,
          statusCode: 451,
          errMessage: 'Unavailable For Legal Reasons',
        );
      case 500:
        return NetworkError(
          errorBody: response,
          statusCode: 500,
          errMessage: 'Internal Server Error',
        );
      case 501:
        return NetworkError(
          errorBody: response,
          statusCode: 501,
          errMessage: 'Not Implemented',
        );
      case 502:
        return NetworkError(
          errorBody: response,
          statusCode: 502,
          errMessage: 'Bad Gateway',
        );
      case 503:
        return NetworkError(
          errorBody: response,
          statusCode: 503,
          errMessage: 'Service Unavailable',
        );
      case 504:
        return NetworkError(
          errorBody: response,
          statusCode: 504,
          errMessage: 'Gateway Timeout',
        );
      case 505:
        return NetworkError(
          errorBody: response,
          statusCode: 505,
          errMessage: 'HTTP Version Not Supported',
        );
      case 506:
        return NetworkError(
          errorBody: response,
          statusCode: 506,
          errMessage: 'Variant Also Negotiates',
        );
      case 507:
        return NetworkError(
          errorBody: response,
          statusCode: 507,
          errMessage: 'Insufficient Storage',
        );
      case 508:
        return NetworkError(
          errorBody: response,
          statusCode: 508,
          errMessage: 'Loop Detected',
        );
      case 510:
        return NetworkError(
          errorBody: response,
          statusCode: 510,
          errMessage: 'Not Extended',
        );
      case 511:
        return NetworkError(
          errorBody: response,
          statusCode: 511,
          errMessage: 'Network Authentication Required',
        );
      default:
        return NetworkError(
          errorBody: response,
          statusCode: statusCode,
          errMessage: 'Oops! There was an error, please try again',
        );
    }
  }
}