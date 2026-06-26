// =============================================================================
// IR Search Engine — lib/models/api_models.dart
// All data models that map to the API Gateway JSON responses.
// =============================================================================

class TopicInfo {
  final int topicId;
  final String topicLabel;
  final List<String> topWords;
  final double probability;

  TopicInfo({
    required this.topicId,
    required this.topicLabel,
    required this.topWords,
    required this.probability,
  });

  factory TopicInfo.fromJson(Map<String, dynamic> json) {
    return TopicInfo(
      topicId: json['topic_id'] as int,
      topicLabel: json['topic_label'] as String,
      topWords: (json['top_words'] as List).map((e) => e as String).toList(),
      probability: (json['probability'] as num).toDouble(),
    );
  }
}

/// Represents a single retrieved document result.
class SearchResultItem {
  final int rank;
  final String docId;
  final double score;
  final String? snippet;
  final TopicInfo? topic;

  SearchResultItem({
    required this.rank,
    required this.docId,
    required this.score,
    this.snippet,
    this.topic,
  });

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    return SearchResultItem(
      rank: json['rank'] as int,
      docId: json['doc_id'] as String,
      score: (json['score'] as num).toDouble(),
      snippet: json['snippet'] as String?,
      topic: json['topic'] != null ? TopicInfo.fromJson(json['topic']) : null,
    );
  }
}

/// Full search response from POST /search.
class SearchResponse {
  final String queryOriginal;
  final String? queryRefined;
  final String queryCleaned;
  final String dataset;
  final String model;
  final List<SearchResultItem> results;
  final double latencyMs;
  final Map<String, dynamic>? refinementInfo;

  SearchResponse({
    required this.queryOriginal,
    this.queryRefined,
    required this.queryCleaned,
    required this.dataset,
    required this.model,
    required this.results,
    required this.latencyMs,
    this.refinementInfo,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      queryOriginal: json['query_original'] as String,
      queryRefined: json['query_refined'] as String?,
      queryCleaned: json['query_cleaned'] as String,
      dataset: json['dataset'] as String,
      model: json['model'] as String,
      results: (json['results'] as List)
          .map((e) => SearchResultItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      latencyMs: (json['latency_ms'] as num).toDouble(),
      refinementInfo: json['refinement_info'] as Map<String, dynamic>?,
    );
  }
}

/// Dataset loading/preprocessing status.
class DatasetStatus {
  final String dataset;
  final String status; // not_loaded | loading | ready | error
  final int progressDocs;
  final int totalDocs;
  final int progressQueries;
  final int totalQueries;
  final String? error;

  DatasetStatus({
    required this.dataset,
    required this.status,
    this.progressDocs = 0,
    this.totalDocs = 0,
    this.progressQueries = 0,
    this.totalQueries = 0,
    this.error,
  });

  factory DatasetStatus.fromJson(Map<String, dynamic> json) {
    return DatasetStatus(
      dataset: json['dataset'] as String,
      status: json['status'] as String,
      progressDocs: (json['progress_docs'] as num?)?.toInt() ?? 0,
      totalDocs: (json['total_docs'] as num?)?.toInt() ?? 0,
      progressQueries: (json['progress_queries'] as num?)?.toInt() ?? 0,
      totalQueries: (json['total_queries'] as num?)?.toInt() ?? 0,
      error: json['error'] as String?,
    );
  }

  double get docProgress =>
      totalDocs > 0 ? progressDocs / totalDocs : 0.0;
}

/// Index build status.
class IndexStatus {
  final String dataset;
  final String status; // not_built | building | ready | error
  final List<String> builtModels;
  final int progress;
  final int total;
  final String? error;

  IndexStatus({
    required this.dataset,
    required this.status,
    required this.builtModels,
    this.progress = 0,
    this.total = 0,
    this.error,
  });

  factory IndexStatus.fromJson(Map<String, dynamic> json) {
    return IndexStatus(
      dataset: json['dataset'] as String,
      status: json['status'] as String,
      builtModels: (json['built_models'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      error: json['error'] as String?,
    );
  }
}

/// Aggregate evaluation metrics.
class AggregateMetrics {
  final String dataset;
  final String model;
  final double map;
  final double meanRecall;
  final double meanPrecisionAtK;
  final double meanNdcgAtK;
  final int numQueries;
  final int k;

  AggregateMetrics({
    required this.dataset,
    required this.model,
    required this.map,
    required this.meanRecall,
    required this.meanPrecisionAtK,
    required this.meanNdcgAtK,
    required this.numQueries,
    required this.k,
  });

  factory AggregateMetrics.fromJson(Map<String, dynamic> json) {
    return AggregateMetrics(
      dataset: json['dataset'] as String,
      model: json['model'] as String,
      map: (json['map'] as num).toDouble(),
      meanRecall: (json['mean_recall'] as num).toDouble(),
      meanPrecisionAtK: (json['mean_precision_at_k'] as num).toDouble(),
      meanNdcgAtK: (json['mean_ndcg_at_k'] as num).toDouble(),
      numQueries: (json['num_queries'] as num).toInt(),
      k: (json['k'] as num).toInt(),
    );
  }
}

/// Health status of all services.
class HealthStatus {
  final String overall; // ok | degraded
  final Map<String, String> services;

  HealthStatus({required this.overall, required this.services});

  factory HealthStatus.fromJson(Map<String, dynamic> json) {
    return HealthStatus(
      overall: json['status'] as String,
      services: Map<String, String>.from(json['services'] as Map),
    );
  }

  bool get isOk => overall == 'ok';
}

/// Descriptor for a retrieval model.
class ModelInfo {
  final String id;
  final String name;
  final String category; // sparse | dense | hybrid
  final String? description;
  final bool tunable;

  ModelInfo({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.tunable = false,
  });

  factory ModelInfo.fromJson(Map<String, dynamic> json) {
    return ModelInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      tunable: json['tunable'] as bool? ?? false,
    );
  }
}
