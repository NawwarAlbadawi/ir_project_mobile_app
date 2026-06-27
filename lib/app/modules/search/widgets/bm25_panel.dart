import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ir_mobile_app/app/modules/search/controllers/search_controller.dart';
import '../../../../config/design_config.dart';
class Bm25Panel extends GetView<AppSearchController> {
  const Bm25Panel({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 95),
      padding: const EdgeInsets.all(16),
      decoration: DesignConfig.glassDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚙️  BM25 Parameter Tuning',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 12,
            children: [
              _SliderGroup(
                label: 'k₁ (term saturation)',
                rxValue: controller.bm25K1,
                min: 0.5,
                max: 3.0,
                divisions: 25,
                onChanged: controller.setBm25K1,
              ),
              _SliderGroup(
                label: 'b (length norm)',
                rxValue: controller.bm25B,
                min: 0.0,
                max: 1.0,
                divisions: 20,
                onChanged: controller.setBm25B,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _SliderGroup extends StatelessWidget {
  final String label;
  final RxDouble rxValue;
  final double min, max;
  final int divisions;
  final void Function(double) onChanged;
  const _SliderGroup({
    required this.label,
    required this.rxValue,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            '$label = ${rxValue.value.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        SizedBox(
          width: 200,
          child: Obx(
            () => Slider(
              value: rxValue.value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$min',
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
            const SizedBox(width: 160),
            Text(
              '$max',
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }
}