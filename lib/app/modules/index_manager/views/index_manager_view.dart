import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../config/design_config.dart';
import '../controllers/index_manager_controller.dart';
class IndexManagerView extends GetView<IndexManagerController> {
  const IndexManagerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: const Text('Index Manager'),
        backgroundColor: AppColors.bgBase,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignConfig.horizontalPadding,
          vertical: 16,
        ),
        child: Column(
          children: [
            _GlassSection(
              title: '📦  Dataset',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select the dataset to load and preprocess.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      children: ['quora', 'msmarco'].map((d) {
                        final sel = controller.selectedDataset.value == d;
                        return ChoiceChip(
                          label: Text(d == 'quora' ? 'BEIR/Quora' : 'MS MARCO'),
                          selected: sel,
                          onSelected: (_) =>
                              controller.selectedDataset.value = d,
                          selectedColor: AppColors.accent.withOpacity(0.2),
                          backgroundColor: AppColors.bgElevated,
                          side: BorderSide(
                            color: sel ? AppColors.accent : AppColors.border,
                            width: sel ? 1.5 : 1,
                          ),
                          labelStyle: TextStyle(
                            color: sel
                                ? AppColors.accent
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => controller.isLoadingDataset.value
                        ? Center(
                            child: LoadingAnimationWidget.discreteCircle(
                              color: AppColors.accent,
                              size: 36,
                            ),
                          )
                        : _AccentButton(
                            label: 'Load Dataset',
                            icon: Icons.download_rounded,
                            onTap: controller.loadDataset,
                          ),
                  ),
                  Obx(() {
                    final s = controller.datasetStatus.value;
                    if (s == null) return const SizedBox();
                    return _StatusBox(
                      label: 'Dataset',
                      status: s.status,
                      subtitle: s.totalDocs > 0
                          ? '${s.progressDocs.toStringWithSeparator()} / ${s.totalDocs.toStringWithSeparator()} docs'
                          : null,
                      error: s.error,
                      progress: s.progress,
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _GlassSection(
              title: '🏗️  Index Builder',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose models to index. Ensure dataset is loaded first.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ModelCheckChip(label: 'TF-IDF', id: 'tfidf'),
                      _ModelCheckChip(label: 'BM25', id: 'bm25'),
                      _ModelCheckChip(label: 'Word2Vec', id: 'word2vec'),
                      _ModelCheckChip(
                        label: 'BERT  ⚠️ Slow on CPU',
                        id: 'bert',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => controller.isBuildingIndex.value
                        ? Center(
                            child: LoadingAnimationWidget.discreteCircle(
                              color: AppColors.accentCyan,
                              size: 36,
                            ),
                          )
                        : _AccentButton(
                            label: 'Build Index',
                            icon: Icons.build_rounded,
                            onTap: controller.buildIndex,
                            color: AppColors.accentCyan,
                          ),
                  ),
                  Obx(() {
                    final s = controller.indexStatus.value;
                    if (s == null) return const SizedBox();
                    return _StatusBox(
                      label: 'Index',
                      status: s.status,
                      subtitle: s.builtModels.isNotEmpty
                          ? 'Built: ${s.builtModels.join(', ')}'
                          : null,
                      error: s.error,
                      progress: s.total > 0 ? s.progress / s.total : 0,
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _GlassSection(
              title: '📡  Status Monitor',
              trailing: TextButton.icon(
                onPressed: controller.refreshAll,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 16,
                  color: AppColors.accentLight,
                ),
                label: const Text(
                  'Refresh',
                  style: TextStyle(fontSize: 12, color: AppColors.accentLight),
                ),
              ),
              child: Obx(() {
                final ds = controller.datasetStatus.value;
                final ix = controller.indexStatus.value;
                if (ds == null && ix == null) {
                  return const Text(
                    'No data yet. Load a dataset first.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  );
                }
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (ds != null)
                      _MonitorCard(title: 'Dataset', status: ds.status),
                    if (ix != null)
                      _MonitorCard(title: 'Index', status: ix.status),
                    if (ix != null && ix.builtModels.isNotEmpty)
                      _MonitorCard(
                        title: 'Models',
                        status: ix.builtModels.join(' · '),
                        isInfo: true,
                      ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
class _GlassSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  const _GlassSection({
    required this.title,
    required this.child,
    this.trailing,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: DesignConfig.glassDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (trailing != null) ...[const Spacer(), trailing!],
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
class _AccentButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  const _AccentButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = AppColors.accent,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: DesignConfig.borderRadius,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
        ),
      ),
    );
  }
}
class _StatusBox extends StatelessWidget {
  final String label, status;
  final String? subtitle, error;
  final double progress;
  const _StatusBox({
    required this.label,
    required this.status,
    this.subtitle,
    this.error,
    this.progress = 0,
  });
  Color get _statusColor {
    switch (status) {
      case 'ready':
        return AppColors.accentGreen;
      case 'error':
        return AppColors.accentPink;
      case 'loading':
      case 'building':
        return AppColors.accentAmber;
      default:
        return AppColors.textMuted;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: DesignConfig.borderRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$label: $status',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _statusColor,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 4),
            Text(
              'Error: $error',
              style: const TextStyle(fontSize: 11, color: AppColors.accentPink),
            ),
          ],
          if ((status == 'loading' || status == 'building') &&
              progress > 0) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.border,
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(999),
            ),
          ],
        ],
      ),
    );
  }
}
class _MonitorCard extends StatelessWidget {
  final String title, status;
  final bool isInfo;
  const _MonitorCard({
    required this.title,
    required this.status,
    this.isInfo = false,
  });
  Color get _color {
    if (isInfo) return AppColors.accentCyan;
    switch (status) {
      case 'ready':
        return AppColors.accentGreen;
      case 'error':
        return AppColors.accentPink;
      default:
        return AppColors.accentAmber;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: DesignConfig.borderRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}
class _ModelCheckChip extends GetView<IndexManagerController> {
  final String label, id;
  const _ModelCheckChip({required this.label, required this.id});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sel = controller.selectedModels.contains(id);
      return FilterChip(
        label: Text(label),
        selected: sel,
        onSelected: (_) => controller.toggleModel(id),
        selectedColor: AppColors.accent.withOpacity(0.2),
        backgroundColor: AppColors.bgElevated,
        checkmarkColor: AppColors.accent,
        side: BorderSide(
          color: sel ? AppColors.accent : AppColors.border,
          width: sel ? 1.5 : 1,
        ),
        labelStyle: TextStyle(
          color: sel ? AppColors.accent : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );
    });
  }
}
extension IntExt on int {
  String toStringWithSeparator() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}