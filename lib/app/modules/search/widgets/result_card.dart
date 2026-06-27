import 'package:flutter/material.dart';
import '../../../../config/design_config.dart';
import '../../../models/api_models.dart';
class ResultCard extends StatelessWidget {
  final SearchResultItem item;
  final int index;
  const ResultCard({super.key, required this.item, required this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgGlass,
        borderRadius: DesignConfig.borderRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: DesignConfig.primaryGradient,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${item.rank}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.docId,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        color: AppColors.accentCyan,
                      ),
                    ),
                    if (item.topic != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          item.topic!.topicLabel,
                          style:  TextStyle(
                            fontSize: 9,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.snippet ?? 'No snippet available.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Score',
                style: TextStyle(fontSize: 9, color: AppColors.textMuted),
              ),
              Text(
                item.score.toStringAsFixed(4),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentGreen,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}