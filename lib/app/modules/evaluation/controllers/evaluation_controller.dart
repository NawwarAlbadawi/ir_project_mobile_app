import 'package:get/get.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import '../../../controllers/network_controllers/ir_repository.dart';
import '../../../models/api_models.dart';
class EvaluationController extends GetxController {
  final _repo = IrRepository.instance;
  final dataset           = 'quora'.obs;
  final model             = 'bm25'.obs;
  final numQueries        = 100.obs;
  final k                 = 10.obs;
  final compareRefinement = true.obs;
  final isRunning      = false.obs;
  final baseMetrics    = Rxn<AggregateMetrics>();
  final refinedMetrics = Rxn<AggregateMetrics>();
  final errorMsg       = ''.obs;
  final datasets = ['quora', 'msmarco'];
  final models = [
    'tfidf', 'bm25', 'word2vec', 'bert',
    'hybrid_serial', 'hybrid_parallel',
  ];
  void setDataset(String v) => dataset.value = v;
  void setModel(String v) => model.value = v;
  void setCompareRefinement(bool v) => compareRefinement.value = v;
  Future<void> runEvaluation() async {
    isRunning.value      = true;
    errorMsg.value       = '';
    baseMetrics.value    = null;
    refinedMetrics.value = null;
    final result = await _repo.evaluate({
      'dataset': dataset.value,
      'model': model.value,
      'num_queries': numQueries.value,
      'k': k.value,
      'compare_refinement': compareRefinement.value,
    });
    result.fold(
      (e) {
        errorMsg.value = e.errMessage;
        CherryToast.error(title: Text(e.errMessage), displayCloseButton: false)
            .show(Get.context!);
      },
      (data) {
        final baseJson    = data['base'] as Map<String, dynamic>?;
        final refinedJson = data['refined'] as Map<String, dynamic>?;
        if (baseJson != null) baseMetrics.value = AggregateMetrics.fromJson(baseJson);
        if (refinedJson != null) refinedMetrics.value = AggregateMetrics.fromJson(refinedJson);
        CherryToast.success(
          title: const Text('Evaluation complete'),
          displayCloseButton: false,
        ).show(Get.context!);
      },
    );
    isRunning.value = false;
  }
}