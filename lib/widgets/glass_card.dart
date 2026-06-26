// =============================================================================
// IR Search Engine — lib/widgets/glass_card.dart
// Shared glassmorphism card widget.
// =============================================================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgGlass,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      padding: padding ?? const EdgeInsets.all(20),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Gradient text widget
// ---------------------------------------------------------------------------
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;

  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.gradient = const LinearGradient(
      colors: [AppColors.accent, AppColors.accentCyan],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

// ---------------------------------------------------------------------------
// Model category badge
// ---------------------------------------------------------------------------
class CategoryBadge extends StatelessWidget {
  final String category;

  const CategoryBadge(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (category) {
      case 'dense':
        color = AppColors.accentCyan;
        break;
      case 'hybrid':
        color = AppColors.accentPink;
        break;
      default:
        color = AppColors.accentLight;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (trailing != null) ...[const Spacer(), trailing!],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Accent chip toggle button
// ---------------------------------------------------------------------------
class AccentChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const AccentChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent.withOpacity(0.2)
              : AppColors.bgElevated,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Labeled slider
// ---------------------------------------------------------------------------
class LabeledSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final String Function(double)? displayValue;

  const LabeledSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.displayValue,
  });

  @override
  Widget build(BuildContext context) {
    final display = displayValue != null
        ? displayValue!(value)
        : value.toStringAsFixed(2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              display,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.accentLight,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$min', style: Theme.of(context).textTheme.bodySmall),
            Text('$max', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Metric comparison tile
// ---------------------------------------------------------------------------
class MetricTile extends StatelessWidget {
  final String label;
  final double baseValue;
  final double? refinedValue;

  const MetricTile({
    super.key,
    required this.label,
    required this.baseValue,
    this.refinedValue,
  });

  @override
  Widget build(BuildContext context) {
    final delta = refinedValue != null ? refinedValue! - baseValue : null;
    final pct = (baseValue > 0 && delta != null)
        ? (delta / baseValue * 100).toStringAsFixed(1)
        : null;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
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
          const SizedBox(height: 10),
          Row(
            children: [
              _ValueBox(
                label: 'Base',
                value: baseValue,
                color: AppColors.accentLight,
              ),
              if (refinedValue != null) ...[
                const SizedBox(width: 12),
                _ValueBox(
                  label: 'Refined',
                  value: refinedValue!,
                  color: AppColors.accentGreen,
                ),
                if (pct != null) ...[
                  const SizedBox(width: 8),
                  _DeltaBadge(delta: delta!, pct: pct),
                ],
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ValueBox extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _ValueBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
        Text(
          value.toStringAsFixed(4),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DeltaBadge extends StatelessWidget {
  final double delta;
  final String pct;
  const _DeltaBadge({required this.delta, required this.pct});

  @override
  Widget build(BuildContext context) {
    final isPos = delta >= 0;
    final color = isPos ? AppColors.accentGreen : AppColors.accentPink;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${isPos ? "+" : ""}$pct%',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
