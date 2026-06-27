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
      topicId: (json['topic_id'] as num).toInt(),
      topicLabel: json['topic_label'] as String,
      topWords: (json['top_words'] as List).map((e) => e as String).toList(),
      probability: (json['probability'] as num).toDouble(),
    );
  }
}
class SearchResultItem {
  final int rank;
  final String docId;
  final double score;
  final String? snippet;
  final TopicInfo? topic;
  const SearchResultItem({
    required this.rank,
    required this.docId,
    required this.score,
    this.snippet,
    this.topic,
  });
  factory SearchResultItem.fromJson(Map<String, dynamic> json) =>
      SearchResultItem(
        rank: (json['rank'] as num).toInt(),
        docId: json['doc_id'] as String,
        score: (json['score'] as num).toDouble(),
        snippet: json['snippet'] as String?,
        topic: json['topic'] != null
            ? TopicInfo.fromJson(json['topic'] as Map<String, dynamic>)
            : null,
      );
}
class SearchResponse {
  final String queryOriginal;
  final String? queryRefined;
  final String queryCleaned;
  final String dataset;
  final String model;
  final List<SearchResultItem> results;
  final double latencyMs;
  final Map<String, dynamic>? refinementInfo;
  const SearchResponse({
    required this.queryOriginal,
    this.queryRefined,
    required this.queryCleaned,
    required this.dataset,
    required this.model,
    required this.results,
    required this.latencyMs,
    this.refinementInfo,
  });
  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
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
class DatasetStatus {
  final String dataset;
  final String status;
  final int progressDocs;
  final int totalDocs;
  final String? error;
  const DatasetStatus({
    required this.dataset,
    required this.status,
    this.progressDocs = 0,
    this.totalDocs = 0,
    this.error,
  });
  factory DatasetStatus.fromJson(Map<String, dynamic> json) => DatasetStatus(
        dataset: json['dataset'] as String,
        status: json['status'] as String,
        progressDocs: (json['progress_docs'] as num?)?.toInt() ?? 0,
        totalDocs: (json['total_docs'] as num?)?.toInt() ?? 0,
        error: json['error'] as String?,
      );
  double get progress => totalDocs > 0 ? progressDocs / totalDocs : 0.0;
}
class IndexStatus {
  final String dataset;
  final String status;
  final List<String> builtModels;
  final int progress;
  final int total;
  final String? error;
  const IndexStatus({
    required this.dataset,
    required this.status,
    required this.builtModels,
    this.progress = 0,
    this.total = 0,
    this.error,
  });
  factory IndexStatus.fromJson(Map<String, dynamic> json) => IndexStatus(
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
class AggregateMetrics {
  final String dataset;
  final String model;
  final double map;
  final double meanRecall;
  final double meanPrecisionAtK;
  final double meanNdcgAtK;
  final int numQueries;
  final int k;
  const AggregateMetrics({
    required this.dataset,
    required this.model,
    required this.map,
    required this.meanRecall,
    required this.meanPrecisionAtK,
    required this.meanNdcgAtK,
    required this.numQueries,
    required this.k,
  });
  factory AggregateMetrics.fromJson(Map<String, dynamic> json) =>
      AggregateMetrics(
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
class HealthStatus {
  final bool isOk;
  final Map<String, String> services;
  const HealthStatus({required this.isOk, required this.services});
  factory HealthStatus.fromJson(Map<String, dynamic> json) => HealthStatus(
        isOk: json['status'] == 'ok',
        services: Map<String, String>.from(json['services'] as Map),
      );
}