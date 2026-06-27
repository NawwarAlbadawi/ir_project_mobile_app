import 'package:get/get.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import '../../../controllers/network_controllers/ir_repository.dart';
import '../../../models/api_models.dart';
class IndexManagerController extends GetxController {
  final _repo = IrRepository.instance;
  final selectedDataset  = 'quora'.obs;
  final selectedModels   = <String>['tfidf', 'bm25', 'word2vec'].obs;
  final isLoadingDataset = false.obs;
  final isBuildingIndex  = false.obs;
  final datasetStatus = Rxn<DatasetStatus>();
  final indexStatus   = Rxn<IndexStatus>();
  final indexStats    = Rxn<Map<String, dynamic>>();
  void toggleModel(String m) {
    if (selectedModels.contains(m)) {
      selectedModels.remove(m);
    } else {
      selectedModels.add(m);
    }
  }
  Future<void> loadDataset() async {
    isLoadingDataset.value = true;
    final result = await _repo.loadDataset(selectedDataset.value);
    result.fold(
      (e) => _toast(e.errMessage, isError: true),
      (_) {
        _toast('Dataset load started — polling…');
        _pollDatasetStatus();
      },
    );
    isLoadingDataset.value = false;
  }
  Future<void> _pollDatasetStatus() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      final r = await _repo.datasetStatus(selectedDataset.value);
      r.fold((_) => null, (s) => datasetStatus.value = s);
      final s = datasetStatus.value?.status;
      if (s == 'ready' || s == 'error') break;
    }
  }
  Future<void> buildIndex() async {
    if (selectedModels.isEmpty) {
      _toast('Select at least one model', isError: true);
      return;
    }
    isBuildingIndex.value = true;
    final result = await _repo.buildIndex(
      selectedDataset.value,
      List.from(selectedModels),
    );
    result.fold(
      (e) => _toast(e.errMessage, isError: true),
      (_) {
        _toast('Index build started…');
        _pollIndexStatus();
      },
    );
    isBuildingIndex.value = false;
  }
  Future<void> _pollIndexStatus() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      final r = await _repo.indexStatus(selectedDataset.value);
      r.fold((_) => null, (s) => indexStatus.value = s);
      final s = indexStatus.value?.status;
      if (s == 'ready' || s == 'error') {
        if (s == 'ready') _fetchStats();
        break;
      }
    }
  }
  Future<void> _fetchStats() async {
    final r = await _repo.indexStats(selectedDataset.value);
    r.fold((_) => null, (s) => indexStats.value = s);
  }
  Future<void> refreshAll() async {
    final dr = await _repo.datasetStatus(selectedDataset.value);
    dr.fold((_) => null, (s) => datasetStatus.value = s);
    final ir = await _repo.indexStatus(selectedDataset.value);
    ir.fold((_) => null, (s) => indexStatus.value = s);
    if (indexStatus.value?.status == 'ready') _fetchStats();
  }
  void _toast(String msg, {bool isError = false}) {
    if (isError) {
      CherryToast.error(title: Text(msg), displayCloseButton: false)
          .show(Get.context!);
    } else {
      CherryToast.success(title: Text(msg), displayCloseButton: false)
          .show(Get.context!);
    }
  }
}