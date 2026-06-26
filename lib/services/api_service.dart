// =============================================================================
// IR Search Engine — lib/services/api_service.dart
// Async HTTP client for the API Gateway (localhost:8000).
// =============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  // Change this if running on a device/emulator
  static const String _baseUrl = 'https://sharpie-broadways-other.ngrok-free.dev';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // -------------------------------------------------------------------------
  // Generic helpers
  // -------------------------------------------------------------------------
  Future<Map<String, dynamic>> _get(String path,
      {Map<String, String>? query}) async {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: query);
    final res = await _client.get(uri).timeout(const Duration(seconds: 30));
    return _handle(res);
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body,
      {Duration timeout = const Duration(seconds: 60)}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final res = await _client
        .post(uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body))
        .timeout(timeout);
    return _handle(res);
  }

  Map<String, dynamic> _handle(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    String detail = res.statusText ?? 'Unknown error';
    try {
      detail = (jsonDecode(res.body) as Map)['detail'] ?? detail;
    } catch (_) {}
    throw ApiException(res.statusCode, detail);
  }

  // -------------------------------------------------------------------------
  // Health
  // -------------------------------------------------------------------------
  Future<HealthStatus> getHealth() async {
    final json = await _get('/health');
    return HealthStatus.fromJson(json);
  }

  // -------------------------------------------------------------------------
  // Models
  // -------------------------------------------------------------------------
  Future<List<ModelInfo>> getModels() async {
    final json = await _get('/models');
    return (json['models'] as List)
        .map((e) => ModelInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // -------------------------------------------------------------------------
  // Search
  // -------------------------------------------------------------------------
  Future<SearchResponse> search({
    required String query,
    required String dataset,
    required String model,
    int topK = 10,
    bool useRefinement = false,
    List<String> refinementTechniques = const ['spell', 'synonyms'],
    String sessionId = 'default',
    double bm25K1 = 1.5,
    double bm25B = 0.75,
    String fusionMethod = 'rrf',
    Map<String, double> hybridWeights = const {
      'tfidf': 0.3,
      'bm25': 0.4,
      'bert': 0.3,
    },
    int serialCandidateK = 100,
  }) async {
    final json = await _post(
      '/search/with-topics',
      {
        'query': query,
        'dataset': dataset,
        'model': model,
        'top_k': topK,
        'use_refinement': useRefinement,
        'refinement_techniques': refinementTechniques,
        'session_id': sessionId,
        'bm25_k1': bm25K1,
        'bm25_b': bm25B,
        'fusion_method': fusionMethod,
        'hybrid_weights': hybridWeights,
        'serial_candidate_k': serialCandidateK,
        'preprocess_stem': true,
        'preprocess_lemmatize': false,
      },
      timeout: const Duration(seconds: 60),
    );
    return SearchResponse.fromJson(json);
  }

  // -------------------------------------------------------------------------
  // Dataset management
  // -------------------------------------------------------------------------
  Future<void> loadDataset(String datasetName) async {
    await _post('/dataset/load', {'dataset_name': datasetName});
  }

  Future<DatasetStatus> getDatasetStatus(String datasetName) async {
    final json = await _get('/dataset/status', query: {'dataset_name': datasetName});
    return DatasetStatus.fromJson(json);
  }

  // -------------------------------------------------------------------------
  // Index management
  // -------------------------------------------------------------------------
  Future<void> buildIndex(String datasetName, List<String> models) async {
    await _post(
      '/index/build',
      {'dataset_name': datasetName, 'models': models},
      timeout: const Duration(minutes: 5),
    );
  }

  Future<IndexStatus> getIndexStatus(String datasetName) async {
    final json = await _get('/index/status', query: {'dataset_name': datasetName});
    return IndexStatus.fromJson(json);
  }

  Future<Map<String, dynamic>> getIndexStats(String datasetName) async {
    return _get('/index/stats', query: {'dataset_name': datasetName});
  }

  // -------------------------------------------------------------------------
  // Evaluation
  // -------------------------------------------------------------------------
  Future<Map<String, dynamic>> evaluateModel({
    required String dataset,
    required String model,
    int numQueries = 100,
    int k = 10,
    bool compareRefinement = true,
  }) async {
    return _post(
      '/search/evaluate',
      {
        'dataset': dataset,
        'model': model,
        'num_queries': numQueries,
        'k': k,
        'compare_refinement': compareRefinement,
      },
      timeout: const Duration(minutes: 10),
    );
  }
}

extension on http.Response {
  String? get statusText => reasonPhrase;
}
