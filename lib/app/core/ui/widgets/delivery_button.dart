import 'package:flutter/material.dart';

class DeliveryButton extends StatelessWidget {
  const DeliveryButton({Key? key, required this.label, required this.onPressed, this.width, this.height})
      : super(key: key);

  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
