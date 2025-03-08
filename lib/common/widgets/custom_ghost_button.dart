import 'package:flutter/material.dart';

class CustomGhostButton extends StatelessWidget {
  final String text;
  final String? highlightedText;
  final VoidCallback onPressed;

  const CustomGhostButton({
    super.key,
    required this.text,
    this.highlightedText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (highlightedText != null) {
      final parts = text.split(highlightedText!);
      return TextButton(
        onPressed: onPressed,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: parts[0]),
              TextSpan(
                text: highlightedText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
