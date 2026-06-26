// lib/app/modules/search/widgets/refinement_banner.dart
import 'package:flutter/material.dart';
import '../../../../config/design_config.dart';

class RefinementBanner extends StatelessWidget {
  final String originalQuery;
  final String refinedQuery;
  final Map<String, dynamic> info;

  const RefinementBanner({
    super.key,
    required this.originalQuery,
    required this.refinedQuery,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    final corrections = info['corrections'] as Map? ?? {};
    final expansions = info['expansions'] as Map? ?? {};

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.08),
        borderRadius: DesignConfig.borderRadius,
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_fix_high_rounded,
                size: 14,
                color: AppColors.accentLight,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Refined: '),
                      TextSpan(
                        text: '"$refinedQuery"',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (corrections.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Corrections: ${corrections.entries.map((e) => '${e.key}→${e.value}').join(', ')}',
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
          if (expansions.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Synonyms: ${expansions.keys.join(', ')}',
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}
