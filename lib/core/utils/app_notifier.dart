import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppNotifier {
  static void show(
    BuildContext context, {
    required String message,
    ToastificationType type = ToastificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.fillColored,
      title: Text(message),
      autoCloseDuration: duration,
      alignment: Alignment.topRight,
      icon: Icon(type.icon),
      primaryColor: _getColor(type),
    );
  }

  static Color _getColor(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return Colors.green;
      case ToastificationType.error:
        return Colors.red;
      case ToastificationType.warning:
        return Colors.orange;
      case ToastificationType.info:
      default:
        return Colors.blue;
    }
  }
}
