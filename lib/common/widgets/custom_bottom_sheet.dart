import 'package:flutter/material.dart';
import 'custom_button.dart';
import 'custom_ghost_button.dart';

class CustomBottomSheet {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool isError = false,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isError ? Colors.red : null,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                if (primaryButtonText != null)
                  CustomButton(
                    text: primaryButtonText,
                    onPressed: () {
                      Navigator.pop(context);
                      onPrimaryPressed?.call();
                    },
                  ),
                if (primaryButtonText != null && secondaryButtonText != null)
                  const SizedBox(height: 12),
                if (secondaryButtonText != null)
                  CustomGhostButton(
                    text: secondaryButtonText,
                    onPressed: () {
                      Navigator.pop(context);
                      onSecondaryPressed?.call();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
