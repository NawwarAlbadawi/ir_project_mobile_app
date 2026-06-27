import 'package:dio/dio.dart';
import '../../cached_service/shared_pref_service.dart';
class AuthInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
  Future<String?> getToken() async {
    return SharedPrefService.instance.getValue(AuthEnum.token);
  }
}
enum AuthEnum { token }