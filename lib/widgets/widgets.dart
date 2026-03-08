import 'package:flutter/material.dart';
import '../theme.dart';

// ── Glass Card ───────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final Color? borderColor;
  final List<BoxShadow>? shadows;

  const GlassCard({super.key, required this.child, this.padding, this.borderRadius = 12, this.borderColor, this.shadows});

  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: CrimsonColors.panel,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor ?? CrimsonColors.border, width: 1),
      boxShadow: shadows,
    ),
    child: child,
  );
}

// ── Neon Primary Button ──────────────────────────────────────
class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;

  const NeonButton({super.key, required this.label, this.onPressed, this.isLoading = false, this.width});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CrimsonColors.crimson2, CrimsonColors.purple],
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: CrimsonColors.crimson.withOpacity(0.4), blurRadius: 24),
          BoxShadow(color: CrimsonColors.purple.withOpacity(0.2), blurRadius: 48),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: isLoading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text(label, style: CrimsonText.hud(size: 13, weight: FontWeight.w700, color: Colors.white)),
      ),
    ),
  );
}

// ── Neon Secondary Button ────────────────────────────────────
class NeonSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const NeonSecondaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: CrimsonColors.blueGlow,
      side: const BorderSide(color: CrimsonColors.blue),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    child: Text(label, style: CrimsonText.hud(size: 12, weight: FontWeight.w700, color: CrimsonColors.blueGlow)),
  );
}

// ── Neon Badge ───────────────────────────────────────────────
class NeonBadge extends StatelessWidget {
  final String label;
  final Color color;

  const NeonBadge({super.key, required this.label, this.color = CrimsonColors.greenL});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.4)),
    ),
    child: Text(label, style: CrimsonText.mono(size: 11, color: color)),
  );
}

// ── Section Header ───────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;

  const SectionHeader({super.key, required this.eyebrow, required this.title});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(eyebrow.toUpperCase(), style: CrimsonText.mono(size: 11, color: CrimsonColors.purpleGl)),
      const SizedBox(height: 8),
      Text(title, style: CrimsonText.hud(size: 24, weight: FontWeight.w700, color: Colors.white), textAlign: TextAlign.center),
    ],
  );
}

// ── Glowing Divider ──────────────────────────────────────────
class GlowDivider extends StatelessWidget {
  const GlowDivider({super.key});

  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    margin: const EdgeInsets.symmetric(vertical: 32),
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [
        Colors.transparent, CrimsonColors.blue, CrimsonColors.purple, Colors.transparent
      ]),
    ),
  );
}

// ── Animated Background Grid ─────────────────────────────────
class GridBackground extends StatelessWidget {
  final Widget child;
  const GridBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      // Dark bg gradient
      Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.6, -0.6),
            radius: 1.2,
            colors: [Color(0x1AA855F7), CrimsonColors.bg],
          ),
        ),
      ),
      Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.8, 0.8),
            radius: 1.0,
            colors: [Color(0x1E3B82F6), Colors.transparent],
          ),
        ),
      ),
      child,
    ],
  );
}

// ── Status Toast ─────────────────────────────────────────────
void showCrimsonToast(BuildContext context, String msg, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg, style: CrimsonText.mono(size: 13, color: Colors.white)),
    backgroundColor: isError ? CrimsonColors.crimson.withOpacity(0.9) : CrimsonColors.panel,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: isError ? CrimsonColors.crimson : CrimsonColors.border),
    ),
    duration: const Duration(seconds: 3),
  ));
}
