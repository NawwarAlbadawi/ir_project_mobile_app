// =============================================================================
// IR Search Engine — lib/providers/app_state.dart
// Central state management using Provider.
// =============================================================================

import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/api_service.dart';

// ---------------------------------------------------------------------------
// Search state
// ---------------------------------------------------------------------------
enum SearchStatus { idle, loading, success, error }

class SearchState extends ChangeNotifier {
  final ApiService _api;

  SearchState(this._api);

  // --- UI-controlled parameters ---
  String dataset = 'quora';
  String model = 'bm25';
  bool useRefinement = false;
  int topK = 10;
  double bm25K1 = 1.5;
  double bm25B = 0.75;
  String fusionMethod = 'rrf';
  Map<String, double> hybridWeights = {'tfidf': 0.3, 'bm25': 0.4, 'bert': 0.3};
  int serialCandidateK = 100;
  String sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';

  // --- Result state ---
  SearchStatus status = SearchStatus.idle;
  SearchResponse? lastResponse;
  String errorMessage = '';

  // ---- Setters that notify ----
  void setDataset(String v)        { dataset = v;        notifyListeners(); }
  void setModel(String v)          { model = v;          notifyListeners(); }
  void setUseRefinement(bool v)    { useRefinement = v;  notifyListeners(); }
  void setTopK(int v)              { topK = v;           notifyListeners(); }
  void setBm25K1(double v)         { bm25K1 = v;         notifyListeners(); }
  void setBm25B(double v)          { bm25B = v;          notifyListeners(); }
  void setFusionMethod(String v)   { fusionMethod = v;   notifyListeners(); }
  void setHybridWeight(String k, double v) {
    hybridWeights = {...hybridWeights, k: v};
    notifyListeners();
  }

  // ---- Search ----
  Future<void> runSearch(String query) async {
    if (query.trim().isEmpty) return;
    status = SearchStatus.loading;
    errorMessage = '';
    notifyListeners();

    try {
      final resp = await _api.search(
        query: query,
        dataset: dataset,
        model: model,
        topK: topK,
        useRefinement: useRefinement,
        refinementTechniques: const ['spell', 'synonyms', 'history'],
        sessionId: sessionId,
        bm25K1: bm25K1,
        bm25B: bm25B,
        fusionMethod: fusionMethod,
        hybridWeights: hybridWeights,
        serialCandidateK: serialCandidateK,
      );
      lastResponse = resp;
      status = SearchStatus.success;
    } on ApiException catch (e) {
      errorMessage = e.message;
      status = SearchStatus.error;
    } catch (e) {
      errorMessage = e.toString();
      status = SearchStatus.error;
    }
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Index Manager state
// ---------------------------------------------------------------------------
enum IndexOp { idle, loadingDataset, buildingIndex }

class IndexState extends ChangeNotifier {
  final ApiService _api;
  IndexState(this._api);

  IndexOp op = IndexOp.idle;
  String? activeDataset;
  DatasetStatus? datasetStatus;
  IndexStatus? indexStatus;
  String? error;
  bool buildBert = false;

  final List<String> selectedModels = ['tfidf', 'bm25', 'word2vec'];

  void toggleModel(String m) {
    if (selectedModels.contains(m)) {
      selectedModels.remove(m);
    } else {
      selectedModels.add(m);
    }
    notifyListeners();
  }

  Future<void> loadDataset(String name) async {
    op = IndexOp.loadingDataset;
    activeDataset = name;
    error = null;
    notifyListeners();
    try {
      await _api.loadDataset(name);
      await _pollDatasetStatus(name);
    } on ApiException catch (e) {
      error = e.message;
      op = IndexOp.idle;
      notifyListeners();
    }
  }

  Future<void> buildIndex(String name) async {
    op = IndexOp.buildingIndex;
    activeDataset = name;
    error = null;
    notifyListeners();
    try {
      await _api.buildIndex(name, List.from(selectedModels));
      await _pollIndexStatus(name);
    } on ApiException catch (e) {
      error = e.message;
      op = IndexOp.idle;
      notifyListeners();
    }
  }

  Future<void> refreshStatus(String name) async {
    try {
      datasetStatus = await _api.getDatasetStatus(name);
      indexStatus = await _api.getIndexStatus(name);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _pollDatasetStatus(String name) async {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      try {
        datasetStatus = await _api.getDatasetStatus(name);
        notifyListeners();
        if (datasetStatus!.status == 'ready' || datasetStatus!.status == 'error') break;
      } catch (_) { break; }
    }
    op = IndexOp.idle;
    notifyListeners();
  }

  Future<void> _pollIndexStatus(String name) async {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      try {
        indexStatus = await _api.getIndexStatus(name);
        notifyListeners();
        if (indexStatus!.status == 'ready' || indexStatus!.status == 'error') break;
      } catch (_) { break; }
    }
    op = IndexOp.idle;
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Evaluation state
// ---------------------------------------------------------------------------
enum EvalStatus { idle, running, success, error }

class EvalState extends ChangeNotifier {
  final ApiService _api;
  EvalState(this._api);

  EvalStatus status = EvalStatus.idle;
  String dataset = 'quora';
  String model = 'bm25';
  int numQueries = 100;
  int k = 10;
  bool compareRefinement = true;

  AggregateMetrics? baseMetrics;
  AggregateMetrics? refinedMetrics;
  String errorMessage = '';

  void setDataset(String v)          { dataset = v;           notifyListeners(); }
  void setModel(String v)            { model = v;             notifyListeners(); }
  void setNumQueries(int v)          { numQueries = v;        notifyListeners(); }
  void setK(int v)                   { k = v;                 notifyListeners(); }
  void setCompareRefinement(bool v)  { compareRefinement = v; notifyListeners(); }

  Future<void> runEvaluation() async {
    status = EvalStatus.running;
    errorMessage = '';
    baseMetrics = null;
    refinedMetrics = null;
    notifyListeners();

    try {
      final json = await _api.evaluateModel(
        dataset: dataset,
        model: model,
        numQueries: numQueries,
        k: k,
        compareRefinement: compareRefinement,
      );
      final baseJson = json['base'] as Map<String, dynamic>?;
      final refinedJson = json['refined'] as Map<String, dynamic>?;
      if (baseJson != null) baseMetrics = AggregateMetrics.fromJson(baseJson);
      if (refinedJson != null) refinedMetrics = AggregateMetrics.fromJson(refinedJson);
      status = EvalStatus.success;
    } on ApiException catch (e) {
      errorMessage = e.message;
      status = EvalStatus.error;
    } catch (e) {
      errorMessage = e.toString();
      status = EvalStatus.error;
    }
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Health state
// ---------------------------------------------------------------------------
class HealthState extends ChangeNotifier {
  final ApiService _api;
  HealthState(this._api);

  HealthStatus? health;

  Future<void> check() async {
    try {
      health = await _api.getHealth();
      notifyListeners();
    } catch (_) {}
  }
}
