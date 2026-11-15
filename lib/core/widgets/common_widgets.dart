import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

/// Orange "Live" pill.
class LiveBadge extends StatelessWidget {
  const LiveBadge({super.key, this.label = 'Live'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: palette.liveBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: palette.liveDot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: palette.liveText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular icon button used over the map and in coloured headers.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.background,
    this.foreground,
    this.elevation = 3,
    this.size = 44,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final Color? background;
  final Color? foreground;
  final double elevation;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final button = Material(
      color: background ?? palette.surface,
      shape: const CircleBorder(),
      elevation: elevation,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: size,
          child: Icon(icon, size: 22, color: foreground ?? palette.ink),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip, child: button);
  }
}

/// Rounded square with a bus icon or a bus number inside.
class BusTile extends StatelessWidget {
  const BusTile({
    super.key,
    this.label,
    this.emphasized = true,
    this.size = 44,
  });

  /// Bus number to show. A bus icon is shown when null.
  final String? label;
  final bool emphasized;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = emphasized ? palette.onPrimary : palette.primaryText;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: emphasized ? palette.primary : palette.primarySoft,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child:
          label == null
              ? Icon(
                Icons.directions_bus_outlined,
                color: foreground,
                size: size * 0.5,
              )
              : Text(
                label!,
                style: TextStyle(
                  color: foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
    );
  }
}

/// Full-page error with a retry action.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 40, color: palette.muted),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.ink, fontSize: 15),
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

/// Placeholder body for tabs and actions that are not built yet.
class ComingSoonView extends StatelessWidget {
  const ComingSoonView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.footer,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: palette.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: palette.primaryText),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.ink,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: palette.primarySoft,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Coming soon',
                style: TextStyle(
                  color: palette.primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.muted, fontSize: 15, height: 1.4),
            ),
            if (footer != null) ...[const SizedBox(height: 32), footer!],
          ],
        ),
      ),
    );
  }
}

/// Snackbar for controls that are in the design but not wired up yet.
void showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$feature is coming soon')));
}
