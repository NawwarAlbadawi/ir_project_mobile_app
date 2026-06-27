import 'package:fpdart/fpdart.dart';
import 'network_error_result.dart';
typedef FutureEither<T> = Future<Either<NetworkErrorResult, T>>;