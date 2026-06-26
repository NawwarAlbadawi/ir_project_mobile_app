// lib/app/modules/search/widgets/model_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../config/design_config.dart';

class ModelCard extends StatelessWidget {
  final String id, name, icon, category;
  final bool isSelected;
  final VoidCallback onTap;

  const ModelCard({
    super.key,
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  Color get _categoryColor {
    if (category.contains('Dense')) return AppColors.accentCyan;
    if (category.contains('Hybrid')) return AppColors.accentPink;
    return AppColors.accentLight;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 180.ms,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withOpacity(0.12)
              : AppColors.bgGlass,
          borderRadius: DesignConfig.borderRadius,
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? DesignConfig.glowShadow : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            Text(
              name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _categoryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                category.split(' ').first.toUpperCase(),
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: _categoryColor,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
