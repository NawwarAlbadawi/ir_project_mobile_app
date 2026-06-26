// =============================================================================
// lib/config/network_service_config/network_service_config.dart
// Mirrors gym_mobile_app's NetworkServiceConfig — initialises Dio for the
// IR System's API Gateway (no auth token needed).
// =============================================================================

import 'package:dio/dio.dart';
import 'package:ir_mobile_app/widgets/dio_interceptor/src/interceptors/fancy_dio_interceptor.dart';
import '../../services/network_service/network_service.dart';

/// Base URL of the IR System API Gateway.
/// Change to your device IP when running on a physical Android device:
/// e.g. 'http://192.168.x.x:8000'
const String kApiBaseUrl = 'http://192.168.1.102:8000';

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
