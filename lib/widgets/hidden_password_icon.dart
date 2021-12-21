import 'package:flutter/material.dart';

class HiddenPasswordIcon extends StatelessWidget {
  bool isCircleOutlined;
  HiddenPasswordIcon({required this.isCircleOutlined, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCircleOutlined) {
      return const Icon(
        Icons.circle_outlined,
        size: 14,
      );
    } else {
      return const Icon(
        Icons.circle_rounded,
        size: 14,
        color: Colors.deepPurple,
      );
    }
  }
}
