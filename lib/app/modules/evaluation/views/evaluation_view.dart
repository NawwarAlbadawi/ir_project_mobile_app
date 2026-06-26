// =============================================================================
// lib/app/modules/evaluation/views/evaluation_view.dart
// =============================================================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../config/design_config.dart';
import '../controllers/evaluation_controller.dart';
import '../../../models/api_models.dart';

class EvaluationView extends GetView<EvaluationController> {
  const EvaluationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: const Text('Retrieval Evaluation'),
        backgroundColor: AppColors.bgBase,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignConfig.horizontalPadding,
          vertical: 16,
        ),
        child: Column(
          children: [
            // ── Settings card ─────────────────────────────────────
            _GlassCard(
              title: '⚙️  Evaluation Settings',
              child: Column(
                children: [
                  // Dataset
                  _DropdownRow(
                    label: 'Dataset',
                    items: controller.datasets,
                    labels: {'quora': 'BEIR/Quora', 'msmarco': 'MS MARCO'},
                    selected: controller.dataset,
                    onChanged: controller.setDataset,
                  ),
                  const SizedBox(height: 12),

                  // Model
                  _DropdownRow(
                    label: 'Model',
                    items: controller.models,
                    labels: {
                      'tfidf': 'TF-IDF',
                      'bm25': 'BM25',
                      'word2vec': 'Word2Vec',
                      'bert': 'BERT',
                      'hybrid_serial': 'Hybrid Serial',
                      'hybrid_parallel': 'Hybrid Parallel',
                    },
                    selected: controller.model,
                    onChanged: controller.setModel,
                  ),
                  const SizedBox(height: 12),

                  // Num queries + K
                  Row(
                    children: [
                      Expanded(
                        child: _IntField(
                          label: 'Queries',
                          rx: controller.numQueries,
                          min: 10,
                          max: 2000,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _IntField(
                          label: 'Rank K',
                          rx: controller.k,
                          min: 1,
                          max: 100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Compare toggle
                  Obx(
                    () => SwitchListTile(
                      value: controller.compareRefinement.value,
                      onChanged: controller.setCompareRefinement,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.accent,
                      title: const Text(
                        'Compare Base vs. Refined',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Run button
                  Obx(
                    () => controller.isRunning.value
                        ? Center(
                            child: LoadingAnimationWidget.discreteCircle(
                              color: AppColors.accent,
                              size: 36,
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: controller.runEvaluation,
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text('Run Evaluation'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: DesignConfig.borderRadius,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Results ───────────────────────────────────────────
            Obx(() {
              final base = controller.baseMetrics.value;
              final refined = controller.refinedMetrics.value;
              if (base == null) return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Evaluation Results',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Model: ${base.model.toUpperCase()} · '
                    '${base.numQueries} queries · K=${base.k}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Metric tiles
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    padding: .zero,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.6,
                    children: [
                      _MetricTile(
                        label: 'MAP',
                        base: base.map,
                        refined: refined?.map,
                      ),
                      _MetricTile(
                        label: 'Mean Recall',
                        base: base.meanRecall,
                        refined: refined?.meanRecall,
                      ),
                      _MetricTile(
                        label: 'P@${base.k}',
                        base: base.meanPrecisionAtK,
                        refined: refined?.meanPrecisionAtK,
                      ),
                      _MetricTile(
                        label: 'nDCG@${base.k}',
                        base: base.meanNdcgAtK,
                        refined: refined?.meanNdcgAtK,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Bar chart comparison
                  if (refined != null)
                    _ComparisonChart(base: base, refined: refined),

                  const SizedBox(height: 100),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _GlassCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: DesignConfig.glassDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  final String label;
  final List<String> items;
  final Map<String, String> labels;
  final RxString selected;
  final void Function(String) onChanged;

  const _DropdownRow({
    required this.label,
    required this.items,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => DropdownButtonFormField<String>(
              value: selected.value,
              items: items
                  .map(
                    (id) => DropdownMenuItem(
                      value: id,
                      child: Text(labels[id] ?? id),
                    ),
                  )
                  .toList(),
              onChanged: (v) => v != null ? onChanged(v) : null,
              dropdownColor: AppColors.bgElevated,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: DesignConfig.borderRadius,
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: DesignConfig.borderRadius,
                  borderSide: const BorderSide(
                    color: AppColors.accent,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.bgElevated,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _IntField extends StatelessWidget {
  final String label;
  final RxInt rx;
  final int min, max;

  const _IntField({
    required this.label,
    required this.rx,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Obx(
          () => TextFormField(
            initialValue: rx.value.toString(),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            onChanged: (v) {
              final parsed = int.tryParse(v);
              if (parsed != null && parsed >= min && parsed <= max) {
                rx.value = parsed;
              }
            },
            decoration: InputDecoration(
              isDense: true,
              suffixText: '$min–$max',
              suffixStyle: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final double base;
  final double? refined;

  const _MetricTile({required this.label, required this.base, this.refined});

  @override
  Widget build(BuildContext context) {
    final delta = refined != null ? refined! - base : null;
    final pct = (base > 0 && delta != null)
        ? (delta / base * 100).toStringAsFixed(1)
        : null;
    final isPos = delta != null && delta >= 0;
    final deltaColor = isPos ? AppColors.accentGreen : AppColors.accentPink;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: DesignConfig.glassDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.7,
            ),
          ),
          if (pct != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: deltaColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${isPos ? "+" : ""}$pct%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: deltaColor,
                ),
              ),
            ),
          ],

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Base',
                    style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                  Text(
                    base.toStringAsFixed(4),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentLight,
                    ),
                  ),
                ],
              ),
              if (refined != null) ...[
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Refined',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      refined!.toStringAsFixed(4),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ComparisonChart extends StatelessWidget {
  final AggregateMetrics base;
  final AggregateMetrics refined;

  const _ComparisonChart({required this.base, required this.refined});

  @override
  Widget build(BuildContext context) {
    const metrics = ['MAP', 'Recall', 'P@K', 'nDCG@K'];
    final baseVals = [
      base.map,
      base.meanRecall,
      base.meanPrecisionAtK,
      base.meanNdcgAtK,
    ];
    final refinedVals = [
      refined.map,
      refined.meanRecall,
      refined.meanPrecisionAtK,
      refined.meanNdcgAtK,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: DesignConfig.glassDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Base vs. Refined Comparison',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: 1.0,
                barGroups: List.generate(metrics.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: baseVals[i],
                        color: AppColors.accentLight,
                        width: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      BarChartRodData(
                        toY: refinedVals[i],
                        color: AppColors.accentGreen,
                        width: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                    barsSpace: 4,
                  );
                }),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) => Text(
                        metrics[v.toInt()],
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (v, _) => Text(
                        v.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: AppColors.border, strokeWidth: 0.5),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: true),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Legend
          Row(
            children: [
              _Legend(color: AppColors.accentLight, label: 'Base'),
              const SizedBox(width: 16),
              _Legend(color: AppColors.accentGreen, label: 'Refined'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
