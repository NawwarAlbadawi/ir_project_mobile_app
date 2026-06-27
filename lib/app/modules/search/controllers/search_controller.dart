import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cherry_toast/cherry_toast.dart';
import '../../../controllers/network_controllers/ir_repository.dart';
import '../../../models/api_models.dart';
class AppSearchController extends GetxController {
  final _repo = IrRepository.instance;
  final dataset = 'quora'.obs;
  final model = 'bm25'.obs;
  final useRefinement = false.obs;
  final topK = 10.obs;
  final bm25K1 = 1.5.obs;
  final bm25B = 0.75.obs;
  final fusionMethod = 'rrf'.obs;
  final hybridWeights = <String, double>{
    'tfidf': 0.3,
    'bm25': 0.4,
    'bert': 0.3,
  }.obs;
  final serialCandidateK = 100.obs;
  final isLoading = false.obs;
  final response = Rxn<SearchResponse>();
  final errorMsg = ''.obs;
  final queryController = TextEditingController();
  final sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
  @override
  void onClose() {
    queryController.dispose();
    super.onClose();
  }
  bool get showBm25Panel =>
      ['bm25', 'hybrid_serial', 'hybrid_parallel'].contains(model.value);
  bool get showHybridPanel => model.value == 'hybrid_parallel';
  void setDataset(String v) => dataset.value = v;
  void setModel(String v) => model.value = v;
  void toggleRefinement() => useRefinement.toggle();
  void setTopK(double v) => topK.value = v.round();
  void setBm25K1(double v) => bm25K1.value = v;
  void setBm25B(double v) => bm25B.value = v;
  void setFusionMethod(String v) => fusionMethod.value = v;
  void setHybridWeight(String k, double v) => hybridWeights[k] = v;
  Future<void> runSearch() async {
    final query = queryController.text.trim();
    if (query.isEmpty) {
      CherryToast.warning(
        title: const Text('Please enter a query'),
        displayCloseButton: false,
      ).show(Get.context!);
      return;
    }
    isLoading.value = true;
    errorMsg.value = '';
    response.value = null;
    final payload = {
      'query': query,
      'dataset': dataset.value,
      'model': model.value,
      'top_k': topK.value,
      'use_refinement': useRefinement.value,
      'refinement_techniques': ['spell', 'synonyms', 'history'],
      'session_id': sessionId,
      'bm25_k1': bm25K1.value,
      'bm25_b': bm25B.value,
      'fusion_method': fusionMethod.value,
      'hybrid_weights': Map<String, dynamic>.from(hybridWeights),
      'serial_candidate_k': serialCandidateK.value,
      'preprocess_stem': true,
      'preprocess_lemmatize': false,
    };
    final result = await _repo.search(payload);
    result.fold((error) {
      errorMsg.value = error.errMessage;
      CherryToast.error(
        title: Text(
          error.errMessage,
          style: TextTheme.of(
            Get.context!,
          ).bodySmall!.copyWith(color: Colors.black),
        ),
        displayCloseButton: false,
      ).show(Get.context!);
    }, (data) => response.value = data);
    isLoading.value = false;
  }
}