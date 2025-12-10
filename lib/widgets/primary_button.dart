import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;
  final List<Color> colors;

  const PrimaryButton({
    Key? key,
    this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 50.0,
    this.icon,
    this.colors = const [],
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors.isEmpty
              ? [
                  context.theme.colorScheme.primary,
                  context.theme.colorScheme.secondary,
                ]
              : colors,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(32),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white),
                        if (text != null) const SizedBox(width: 8),
                      ],
                      if (text != null)
                        Text(
                          text!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
