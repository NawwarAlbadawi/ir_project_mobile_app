import '../../../services/network_service/network_service.dart';
import '../../../services/network_service/future_either.dart';
import '../../models/api_models.dart';
class IrRepository {
  IrRepository._();
  static final instance = IrRepository._();
  final _net = NetworkService.instance;
  FutureEither<HealthStatus> getHealth() => _net.getData(
        url: '/health',
        successHandler: (r) => HealthStatus.fromJson(r.data),
      );
  FutureEither<SearchResponse> search(Map<String, dynamic> payload) =>
      _net.post(
        url: '/search/with-topics',
        bodyParameters: payload,
        successHandler: (r) => SearchResponse.fromJson(r.data),
      );
  FutureEither<Map<String, dynamic>> loadDataset(String name) => _net.post(
        url: '/dataset/load',
        bodyParameters: {'dataset_name': name},
        successHandler: (r) => r.data as Map<String, dynamic>,
      );
  FutureEither<DatasetStatus> datasetStatus(String name) => _net.getData(
        url: '/dataset/status',
        queryParameters: {'dataset_name': name},
        successHandler: (r) => DatasetStatus.fromJson(r.data),
      );
  FutureEither<Map<String, dynamic>> buildIndex(
          String name, List<String> models) =>
      _net.post(
        url: '/index/build',
        bodyParameters: {'dataset_name': name, 'models': models},
        successHandler: (r) => r.data as Map<String, dynamic>,
      );
  FutureEither<IndexStatus> indexStatus(String name) => _net.getData(
        url: '/index/status',
        queryParameters: {'dataset_name': name},
        successHandler: (r) => IndexStatus.fromJson(r.data),
      );
  FutureEither<Map<String, dynamic>> indexStats(String name) => _net.getData(
        url: '/index/stats',
        queryParameters: {'dataset_name': name},
        successHandler: (r) => r.data as Map<String, dynamic>,
      );
  FutureEither<Map<String, dynamic>> evaluate(Map<String, dynamic> payload) =>
      _net.post(
        url: '/search/evaluate',
        bodyParameters: payload,
        successHandler: (r) => r.data as Map<String, dynamic>,
      );
}