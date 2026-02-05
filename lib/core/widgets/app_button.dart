import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String name;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color color;

  const AppButton({
    super.key,
    required this.name,
    required this.icon,
    required this.onPressed,
    this.color = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
