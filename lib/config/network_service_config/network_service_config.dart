import 'package:dio/dio.dart';
import 'package:ir_mobile_app/widgets/dio_interceptor/src/interceptors/fancy_dio_interceptor.dart';
import '../../services/network_service/network_service.dart';
const String kApiBaseUrl = 'http://192.168.1.11:8000';
abstract class NetworkServiceConfig {
  static void initNetworkService() {
    NetworkService.initDio(
      baseUrl: kApiBaseUrl,
      interceptors: [
        FancyDioInterceptor(),
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (o) => print(o.toString()),
        ),
      ],
    );
  }
}