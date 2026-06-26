// =============================================================================
// lib/app/modules/search/views/search_view.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ir_mobile_app/app/modules/search/controllers/search_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../config/design_config.dart';
import '../widgets/model_card.dart';
import '../widgets/result_card.dart';
import '../widgets/bm25_panel.dart';
import '../widgets/hybrid_panel.dart';
import '../widgets/refinement_banner.dart';

class SearchView extends GetView<AppSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            backgroundColor: AppColors.bgBase,
            flexibleSpace: FlexibleSpaceBar(background: _HeroHeader()),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignConfig.horizontalPadding,
              vertical: 8,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Search Bar ──────────────────────────────────────
                _SearchBar(),
                const SizedBox(height: 16),

                // ── Dataset + Mode toggles ──────────────────────────
                _ControlsRow(),
                const SizedBox(height: 16),

                // ── Model Grid ─────────────────────────────────────
                _SectionLabel('Retrieval Model'),
                const SizedBox(height: 10),
                const _ModelGrid(),
                const SizedBox(height: 20),

                // ── BM25 Panel ─────────────────────────────────────
                Obx(
                  () => controller.showBm25Panel
                      ? const Bm25Panel().animate().fadeIn()
                      : const SizedBox.shrink(),
                ),

                // ── Hybrid Parallel Panel ──────────────────────────
                Obx(
                  () => controller.showHybridPanel
                      ? const HybridPanel().animate().fadeIn()
                      : const SizedBox(),
                ),

                // ── Results ────────────────────────────────────────
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: AppColors.accent,
                          size: 48,
                        ),
                      ),
                    );
                  }
                  final resp = controller.response.value;
                  if (resp == null) return const SizedBox();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Results header
                      Wrap(
                        children: [
                          _SectionLabel('Results for "${resp.queryOriginal}"'),

                          _MetaBadge(
                            '${resp.results.length} results · ${resp.latencyMs.toStringAsFixed(1)} ms',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Refinement banner
                      if (resp.refinementInfo != null &&
                          resp.queryRefined != null)
                        RefinementBanner(
                          originalQuery: resp.queryOriginal,
                          refinedQuery: resp.queryRefined!,
                          info: resp.refinementInfo!,
                        ),

                      const SizedBox(height: 12),

                      // Result cards
                      ...resp.results.asMap().entries.map(
                        (e) => ResultCard(item: e.value, index: e.key)
                            .animate(delay: (e.key * 40).ms)
                            .slideY(
                              begin: 0.3,
                              end: 0,
                              duration: 300.ms,
                              curve: Curves.easeOut,
                            ),
                      ),
                      const SizedBox(height: 200), // nav bar space
                    ],
                  );
                }),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.bgBase, AppColors.bgSurface],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (b) => DesignConfig.titleGradient.createShader(
              Rect.fromLTWH(0, 0, b.width, b.height),
            ),
            blendMode: BlendMode.srcIn,
            child: const Text(
              'IR Search Engine',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'TF-IDF · BM25 · Word2Vec · BERT · Hybrid',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends GetView<AppSearchController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.queryController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Enter your query…',
              prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
            ),
            onSubmitted: (_) => controller.runSearch(),
          ),
        ),
        const SizedBox(width: 10),
        Obx(
          () => AnimatedContainer(
            duration: 200.ms,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.runSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: DesignConfig.borderRadius,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                elevation: 0,
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.bolt_rounded),
            ),
          ),
        ),
      ],
    );
  }
}

class _ControlsRow extends GetView<AppSearchController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: DesignConfig.glassDecoration,
      child: Wrap(
        spacing: 20,
        runSpacing: 12,
        children: [
          // Dataset
          _ToggleGroup(
            label: 'Dataset',
            options: const ['quora', 'msmarco'],
            labels: const ['BEIR/Quora', 'MS MARCO'],
            selected: controller.dataset,
            onSelect: controller.setDataset,
          ),

          // Mode
          _ToggleGroup(
            label: 'Execution Mode',
            options: const ['false', 'true'],
            labels: const ['Base', '+ Refinements'],
            selected: controller.useRefinement.value ? 'true'.obs : 'false'.obs,
            onSelect: (v) => controller.useRefinement.value = v == 'true',
          ),

          // Top-K
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  'Top-K: ${controller.topK.value}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              SizedBox(
                width: 160,
                child: Obx(
                  () => Slider(
                    value: controller.topK.value.toDouble(),
                    min: 5,
                    max: 50,
                    divisions: 9,
                    onChanged: controller.setTopK,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleGroup extends StatelessWidget {
  final String label;
  final List<String> options;
  final List<String> labels;
  final RxString selected;
  final void Function(String) onSelect;

  const _ToggleGroup({
    required this.label,
    required this.options,
    required this.labels,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Obx(
          () => Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: DesignConfig.borderRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                options.length,
                (i) => GestureDetector(
                  onTap: () => onSelect(options[i]),
                  child: AnimatedContainer(
                    duration: 180.ms,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: selected.value == options[i]
                          ? AppColors.bgSurface
                          : Colors.transparent,
                      borderRadius: DesignConfig.borderRadius,
                      border: selected.value == options[i]
                          ? Border.all(color: AppColors.borderHover)
                          : null,
                    ),
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: selected.value == options[i]
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ModelGrid extends GetView<AppSearchController> {
  const _ModelGrid();

  static const _models = [
    {'id': 'tfidf', 'name': 'TF-IDF', 'icon': '📊', 'cat': 'Sparse'},
    {'id': 'bm25', 'name': 'BM25', 'icon': '🎯', 'cat': 'Sparse · Tunable'},
    {'id': 'word2vec', 'name': 'Word2Vec', 'icon': '🌐', 'cat': 'Dense'},
    {'id': 'bert', 'name': 'BERT', 'icon': '🤖', 'cat': 'Dense'},
    {
      'id': 'hybrid_serial',
      'name': 'Hybrid Serial',
      'icon': '🔗',
      'cat': 'Hybrid',
    },
    {
      'id': 'hybrid_parallel',
      'name': 'Hybrid Parallel',
      'icon': '⚡',
      'cat': 'Hybrid',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: .zero,
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.2,
      children: _models
          .map(
            (m) => Obx(
              () => ModelCard(
                id: m['id']!,
                name: m['name']!,
                icon: m['icon']!,
                category: m['cat']!,
                isSelected: controller.model.value == m['id'],
                onTap: () => controller.setModel(m['id']!),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final String text;
  const _MetaBadge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
      ),
    );
  }
}
