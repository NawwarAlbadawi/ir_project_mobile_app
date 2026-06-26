import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import 'network_error_result.dart';
import 'future_either.dart';

class NetworkService {
  NetworkService._();
  static late Dio dio;
  static final instance = NetworkService._();
  static bool isInit = false;

  static void initDio({
    required List<Interceptor> interceptors,
    required String baseUrl,
  }) {
    if (isInit) {
      return;
    }
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.addAll(interceptors);
    isInit = true;
  }

  FutureEither<T> post<T>({
    Object? bodyParameters,
    required String url,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    required T Function(Response) successHandler,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      var result = await dio.post(
        url,
        data: bodyParameters,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return Right(successHandler(result));
    } catch (e) {
      if (e is DioException) {
        return Left(NetworkError.fromDioError(e));
      }
      return Left(NetworkError(errorBody: e, errMessage: e.toString()));
    }
  }

  FutureEither<T> getData<T>({
    Map<String, dynamic>? bodyParameters,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    required T Function(Response) successHandler,

    required String url,
  }) async {
    try {
      var res = await dio.get(
        url,
        data: bodyParameters,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
    
      );
      return Right(successHandler(res));
    } catch (e) {
      if (e is DioException) {
        return Left(NetworkError.fromDioError(e));
      }
      return Left(NetworkError(errorBody: e, errMessage: e.toString()));
    }
  }

  FutureEither<T> putData<T>({
    Object? bodyParameters,
    required String url,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    required T Function(Response) successHandler,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      var result = await dio.put(
        url,
        data: bodyParameters,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return Right(successHandler(result));
    } catch (e) {
      if (e is DioException) {
        return Left(NetworkError.fromDioError(e));
      }
      return Left(NetworkError(errorBody: e, errMessage: e.toString()));
    }
  }

  FutureEither<T> deleteData<T>({
    Object? bodyParameters,
    required String url,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    required T Function(Response) successHandler,
  }) async {
    try {
      var result = await dio.delete(
        url,
        data: bodyParameters,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return Right(successHandler(result));
    } catch (e) {
      if (e is DioException) {
        return Left(NetworkError.fromDioError(e));
      }
      return Left(NetworkError(errorBody: e, errMessage: e.toString()));
    }
  }
}
