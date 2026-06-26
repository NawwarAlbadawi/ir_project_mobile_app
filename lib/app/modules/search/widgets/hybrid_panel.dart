// lib/app/modules/search/widgets/hybrid_panel.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ir_mobile_app/app/modules/search/controllers/search_controller.dart';
import '../../../../config/design_config.dart';

class HybridPanel extends GetView<AppSearchController> {
  const HybridPanel({super.key});

  static const _methods = ['rrf', 'linear', 'combmnz'];
  static const _labels = ['RRF', 'Linear', 'CombMNZ'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: DesignConfig.glassDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔀  Fusion Method',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          // Fusion method toggle
          Obx(
            () => Wrap(
              spacing: 6,
              children: List.generate(_methods.length, (i) {
                final sel = controller.fusionMethod.value == _methods[i];
                return GestureDetector(
                  onTap: () => controller.setFusionMethod(_methods[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.accent.withOpacity(0.2)
                          : AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: sel ? AppColors.accent : AppColors.border,
                        width: sel ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      _labels[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: sel ? AppColors.accent : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Weight sliders (shown only for linear)
          Obx(
            () => controller.fusionMethod.value == 'linear'
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _WeightSlider(label: 'TF-IDF', index: 'tfidf'),
                        _WeightSlider(label: 'BM25', index: 'bm25'),
                        _WeightSlider(label: 'BERT', index: 'bert'),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _WeightSlider extends GetView<AppSearchController> {
  final String label;
  final String index;
  const _WeightSlider({required this.label, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            '$label weight = ${(controller.hybridWeights[index] ?? 0.3).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        SizedBox(
          width: 180,
          child: Obx(
            () => Slider(
              value: controller.hybridWeights[index] ?? 0.3,
              min: 0.0,
              max: 1.0,
              divisions: 20,
              onChanged: (v) => controller.setHybridWeight(index, v),
            ),
          ),
        ),
      ],
    );
  }
}
